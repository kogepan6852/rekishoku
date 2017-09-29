class ApiStoriesController < ApplicationController
  authorize_resource :class => false

  include Prerender
  include ShopInfo
  include RelatedInfo

  # GET /api/stories
  # 一覧表示
  def index
    print("1234567890")
    @posts = Story.joins(:category).select('stories.*, categories.id as category_id, categories.slug as category_slug').where("status = ? and published_at <= ?", 1, Time.zone.now).order(published_at: :desc, id: :desc)
    # フリーワードで検索
    if params[:keywords]
      keywords = params[:keywords]
      for kw in keywords.gsub("　", " ").split(" ")
        # タイトル&本文で検索
        @posts = @posts
          .joins(:post_details)
          .where('stories.title LIKE ? or stories.content LIKE ? or post_details.title LIKE ? or post_details.content LIKE ?', "%#{kw}%", "%#{kw}%" , "%#{kw}%", "%#{kw}%").uniq
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

    # ライターで検索
    if params[:writer]
      @posts = @posts.where("user_id = ?", params[:writer])
    end

    if params[:page] && params[:per]
      @posts = @posts.page(params[:page]).per(params[:per])
    end

    newPosts = Array.new()
    @posts.each do |post|
      newPosts.push(get_post_json(post))
    end
    render json: newPosts
  end

  # GET /api/stories/1
  # 詳細データ表示
  def show
    @post = Story.joins(:category).select('stories.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').find(params[:id])

    if params[:preview] == "true" || @post.status == 1
      # user情報整形
      user = {
        "id" => @post.user.id,
        "username" => @post.user.username,
        "image" => @post.user.image.thumb }
      # people情報整形
      people = Array.new()
      @post.people.order(rating: :desc).each do |person|
        if person[:rating] != 0.0
          people.push(person);
        end
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
      shops = @post.shops.joins("LEFT OUTER JOIN periods ON shops.period_id = periods.id").select('shops.*, periods.name as period_name')
      newShops = Array.new()
      shops.each do |shop|
        newShops.push(get_shop_json(shop));
      end

      post = {
        "stories" => @post,
        "shops" => newShops,
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

  # GET /api/stories_list
  # post-list用一覧表示
  def list
    @posts = Story.joins(:category).select('stories.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').order(created_at: :desc)
    @posts = @posts.where(user_id: current_user.id)
    render json: @posts.page(params[:page]).per(params[:per])
  end

  # GET /api/stories_related
  # 関連post
  def relation
    if params[:type] != "1"
      # 対象postに紐付く時代を取得する
      period = Person.select('periods.id').joins(:posts).joins(:periods)
        .where('posts.id = ? ', params[:id])
      # 対象のperiodに紐づくpostを取得する
      person = Person.select('people.id').joins(:periods)
        .where('periods.id' => period)
      posts = Story.joins(:category).joins(:people)
        .select('distinct stories.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug')
        .where('people.id' => person)
        .where('posts.id != ?', params[:id])
        .where("status = ? and published_at <= ?", 1, Time.zone.now)
        .order('posts.created_at desc')
        .limit(10)
    else
      # 対象postに紐付くcategoryを取得する
      category_id = Story.select("category_id").where(id: params[:id])
      # 対象のcategoryに紐づくpostを取得する
      posts = Story.joins(:category)
        .select('distinct stories.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug')
        .where(category_id: category_id)
        .where('posts.id != ?', params[:id])
        .where("status = ? and published_at <= ?", 1, Time.zone.now)
        .order('posts.created_at desc')
        .limit(10)
    end

    # 返却用オブジェクト作成
    newPosts = Array.new()
    posts.each do |post|
      newPosts.push(get_post_json(post))
    end

    render json: newPosts
  end

  # POST /stories
  # 新規作成
  def create
    category = StoryCategory.find_by(slug: params[:slug])
    @post = Story.new(story_params.merge(user_id: current_user.id, category_id: category.id))
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stories/1
  # 更新
  def update
    @post = Story.where(user_id: current_user.id).find(params[:id])
    # 公開処理(ステータス更新)でない場合
    if story_params[:status].blank?
      category = StoryCategory.find_by(slug: params[:slug])
      # 記事の掲載元のパラメータ判定
      if post_params[:quotation_url] && post_params[:quotation_name]
        result = @post.update(story_params.merge(category_id: category.id))
      else
        result = @post.update(story_params.merge(category_id: category.id, quotation_url: nil, quotation_name: nil))
      end
    # 公開処理の場合
    else
      # アイキャッチ画像設定
      eyeCatchImage = @post.image
      @post.post_details.each do |post_detail|
        if post_detail.is_eye_catch
          eyeCatchImage = post_detail.image
        end
      end
      cache_url = "https://www.rekishoku.jp/app/post/" + @post[:id].to_s
      create_page_cache(cache_url, eyeCatchImage, @post[:title], @post[:content])
      result = @post.update(post_params)
    end
    if result
      render json: @post, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stories/1
  # 削除
  def destroy
    @post = Story.where(user_id: current_user.id).find(params[:id])
    @post.destroy
    head :no_content
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:title, :content, :image, :favorite_count, :status, :user_id, :quotation_url, :quotation_name, :category_id, :memo, :published_at, :is_eye_catch, :is_map)
    end

end
