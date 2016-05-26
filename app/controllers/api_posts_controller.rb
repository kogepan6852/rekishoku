class ApiPostsController < ApplicationController
  authorize_resource :class => false

  include ShopInfo
  include RelatedInfo

  # GET /api/posts
  # 一覧表示
  def index
    @posts = Post.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').where("status = ? and published_at <= ?", 1, Date.today).order(published_at: :desc)
    # フリーワードで検索
    if params[:keywords]
      keywords = params[:keywords]
      for kw in keywords.split(" ")
        # タイトル&本文で検索
        @posts = @posts
          .joins(:post_details)
          .where('posts.title LIKE ? or posts.content LIKE ? or post_details.title LIKE ? or post_details.content LIKE ?', "%#{kw}%", "%#{kw}%" , "%#{kw}%", "%#{kw}%").uniq
      end
    end

    # カテゴリーで検索
    if params[:category]
      @posts = @posts.where(category_id: params[:category].to_i)
    end

    # 時代で検索
    if params[:period]
      person = Person.select('distinct people.id').joins(:periods)
        .where('periods.id' => params[:period])
      @posts = @posts.joins(:people).where('people.id' => person).uniq
    end

    # 人物で検索
    if params[:person]
      @posts = @posts.joins(:people).where('people.id' => params[:person]).uniq
    end

    # 人物で検索
    if params[:province]
      @posts = @posts.joins(:shops).where('shops.province' => params[:province]).uniq
    end

    newPosts = Array.new()
    @posts.page(params[:page]).per(params[:per]).each do |post|
      # アイキャッチ画像の設定
      postObj = get_post(post)

      # 人に紐付く時代を全て抽出する
      periods = get_periods(post.people)

      # 返却用のオブジェクトを作成する
      obj = { "post" => postObj,
              "people" => post.people,
              "periods" => periods.uniq
            }

      newPosts.push(obj);
    end

    render json: newPosts
  end

  # GET /api/posts/1
  # 詳細データ表示
  def show
    @post = Post.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').find(params[:id])
    logger.debug(params[:preview])
    if params[:preview] == "true" || @post.status == 1 && @post.published_at <= Date.today
      # user情報整形
      user = {
        "id" => @post.user.id,
        "username" => @post.user.username,
        "image" => @post.user.image.thumb }
      # people情報整形
      people = Array.new()
      @post.people.each do |person|
        obj = {
          "id" => person.id,
          "name" => person.name,
          "furigana" => person.furigana}
        people.push(obj);
      end

      # アイキャッチ画像設定
      eyeCatchImage = @post.image
      @post.post_details.each do |post_detail|
        if post_detail.is_eye_catch
          eyeCatchImage = post_detail.image
        end
      end

      # 人に紐付く時代を全て抽出する
      postPeriods = get_periods(@post.people)

      # shop情報整形
      shops = Array.new()
      @post.shops.each do |shop|
        # 人に紐付く時代を全て抽出する
        shopPeriods = Array.new()
        shop.people.each do |person|
          person.periods.each do |period|
            shopPeriods.push(period);
          end
        end

        # 歴食度の設定
        rating = cal_rating(shop)
        # 価格帯の取得
        price = get_price(shop)

        obj = { "shop" => shop,
                "categories" => shop.categories,
                "people" => shop.people,
                "periods" => shopPeriods.uniq,
                "rating" => rating,
                "price" => price
              }
        shops.push(obj);
      end

      post = {
        "post" => @post,
        "shops" => shops,
        "user" => user,
        "people" => people,
        "periods" => postPeriods.uniq,
        "eye_catch_image" => eyeCatchImage }
      render json: post
    else
      post = { "post" => "" }
      render json: post
    end
  end

  # GET /api/posts_list
  # post-list用一覧表示
  def list
    @posts = Post.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').order(created_at: :desc)
    @posts = @posts.where(user_id: current_user.id)
    render json: @posts.page(params[:page]).per(params[:per])
  end

  # GET /api/posts_related
  # 関連post
  def relation
    if params[:type] != "1"
      # 対象postに紐付く時代を取得する
      period = Person.select('periods.id').joins(:posts).joins(:periods)
        .where('posts.id = ? ', params[:id])
      # 対象のperiodに紐づくpostを取得する
      person = Person.select('people.id').joins(:periods)
        .where('periods.id' => period)
      posts = Post.joins(:category).joins(:people)
        .select('distinct posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug')
        .where('people.id' => person)
        .where('posts.id != ?', params[:id])
        .where("status = ? and published_at <= ?", 1, Date.today)
        .order('posts.created_at desc')
        .limit(10)
    else
      # 対象postに紐付くcategoryを取得する
      category_id = Post.select("category_id").where(id: params[:id])
      # 対象のcategoryに紐づくpostを取得する
      posts = Post.joins(:category)
        .select('distinct posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug')
        .where(category_id: category_id)
        .where('posts.id != ?', params[:id])
        .where("status = ? and published_at <= ?", 1, Date.today)
        .order('posts.created_at desc')
        .limit(10)
    end

    # 返却用オブジェクト作成
    newPosts = Array.new()
    posts.each do |post|
      # アイキャッチ画像の設定
      postObj = get_post(post)

      # 人に紐付く時代を全て抽出する
      periods = get_periods(post.people)

      obj = { "post" => postObj,
              "people" => post.people,
              "periods" => periods
            }

      newPosts.push(obj)
    end

    render json: newPosts
  end

  # POST /posts
  # 新規作成
  def create
    category = PostCategory.find_by(slug: params[:slug])
    @post = Post.new(post_params.merge(user_id: current_user.id, category_id: category.id))

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  # 更新
  def update
    @post = Post.where(user_id: current_user.id).find(params[:id])
    # 公開処理(ステータス更新)でない場合
    if post_params[:status].blank?
      category = PostCategory.find_by(slug: params[:slug])
      # 記事の掲載元のパラメータ判定
      if post_params[:quotation_url] && post_params[:quotation_name]
        result = @post.update(post_params.merge(category_id: category.id))
      else
        result = @post.update(post_params.merge(category_id: category.id, quotation_url: nil, quotation_name: nil))
      end
    # 公開処理の場合
    else
      result = @post.update(post_params)
    end
    if result
      render json: @post, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  # 削除
  def destroy
    @post = Post.where(user_id: current_user.id).find(params[:id])
    @post.destroy
    head :no_content
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :image, :favorite_count, :status, :user_id, :quotation_url, :quotation_name, :category_id, :memo, :published_at, :is_eye_catch)
    end

end
