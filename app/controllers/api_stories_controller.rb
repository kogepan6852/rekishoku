class ApiStoriesController < ApplicationController

  include Prerender
  include ShopInfo
  include RelatedInfo

  # GET /api/stories
  # 一覧表示
  def index
    @stories = Story.joins(:category).joins("LEFT OUTER JOIN category_translations ON stories.category_id = category_translations.category_id")
    .select('stories.*, categories.id as category_id, category_translations.name as category_name, categories.slug as category_slug').where("status = ? and published_at <= ?", 1, Time.zone.now).order(published_at: :desc, id: :desc)
    # フリーワードで検索
    if params[:keywords]
      keywords = params[:keywords]
      for kw in keywords.gsub("　", " ").split(" ")
        # タイトル&本文で検索
        @stories = @stories
          .joins(:post_details)
          .where('stories.title LIKE ? or stories.content LIKE ? or post_details.title LIKE ? or post_details.content LIKE ?', "%#{kw}%", "%#{kw}%" , "%#{kw}%", "%#{kw}%").uniq
      end
    end

    # カテゴリーで検索
    if params[:category]
      @stories = @stories.where(category_id: params[:category].to_i)
    end

    # 時代で検索
    if params[:period]
      person = Person.select('distinct people.id').joins(:periods)
        .where('periods.id' => params[:period])
      @stories = @stories.joins(:people).where('people.id' => person).uniq
    end

    # 人物で検索
    if params[:person]
      @stories = @stories.joins(:people).where('people.id' => params[:person]).uniq
    end

    # 人物で検索
    if params[:province]
      @stories = @stories.joins(:shops).where('shops.province' => params[:province]).uniq
    end

    # ライターで検索
    if params[:writer]
      @stories = @stories.where("user_id = ?", params[:writer])
    end

    if params[:page] && params[:per]
      @stories = @stories.page(params[:page]).per(params[:per])
    end

    # shop_id対応
    if params[:shop_id]
      storiesShop = StoriesShop.where(shop_id: params[:shop_id].to_i)
      if storiesShop.count != 0
        newStoryId = Array.new()
        storiesShop.each do |storiesshop|
          newStoryId.push(storiesshop.story_id)
        end
        @stories = @stories.where('id' =>  newStoryId).uniq
      else
        @stories = {}
      end
    end

    newPosts = Array.new()
    @stories.each do |story|
      newPosts.push(get_story_json(story))
    end
    render json: newPosts
  end

  # GET /api/stories/1
  # 詳細データ表示
  def show
    @story = Story.joins(:category).joins("LEFT OUTER JOIN category_translations ON stories.category_id = category_translations.category_id")
    .select('stories.*, categories.id as category_id, category_translations.name as category_name, categories.slug as category_slug').find(params[:id])

    if params[:preview] == "true" || @story.status == 1
      people = Array.new()
      @story.people.order(rating: :desc).each do |person|
        if person[:rating] != 0.0
          people.push(person);
        end
      end

      # アイキャッチ画像設定
      eyeCatchImage = @story.image
      @story.story_details.each do |story_detail|
        if story_detail.is_eye_catch
          eyeCatchImage = post_detail.image
        end
      end

      # 人に紐付く時代を全て抽出する
      postPeriods = get_periods(@story.people)

      # # shop情報整形
      # shops = @story.shops.joins("LEFT OUTER JOIN periods ON shops.period_id = periods.id").select('shops.*, periods.name as period_name')
      # newShops = Array.new()
      # shops.each do |shop|
      #   newShops.push(get_shop_json(shop));
      # end
      story = @story.attributes
      story["image"] = @story.image
      story["user_name"] = @story.user.username
      story["people"] = people
      story["periods"] = postPeriods.uniq
      story["eye_catch_image"] = eyeCatchImage
      render json: story
    else
      story = {}
      render json: story
    end
  end

  # GET /api/stories_list
  # post-list用一覧表示
  def list
    @stories = Story.joins(:category).select('stories.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').order(created_at: :desc)
    @stories = @stories.where(user_id: current_user.id)
    render json: @stories.page(params[:page]).per(params[:per])
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
      newPosts.push(get_story_json(post))
    end

    render json: newPosts
  end

  # POST /stories
  # 新規作成
  def create
    category = StoryCategory.find_by(slug: params[:slug])
    @story = Story.new(story_params.merge(user_id: current_user.id, category_id: category.id))
    if @story.save
      render json: @story, status: :created
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stories/1
  # 更新
  def update
    @story = Story.where(user_id: current_user.id).find(params[:id])
    # 公開処理(ステータス更新)でない場合
    if story_params[:status].blank?
      category = StoryCategory.find_by(slug: params[:slug])
      # 記事の掲載元のパラメータ判定
      if post_params[:quotation_url] && post_params[:quotation_name]
        result = @story.update(story_params.merge(category_id: category.id))
      else
        result = @story.update(story_params.merge(category_id: category.id, quotation_url: nil, quotation_name: nil))
      end
    # 公開処理の場合
    else
      # アイキャッチ画像設定
      eyeCatchImage = @story.image
      @story.post_details.each do |post_detail|
        if post_detail.is_eye_catch
          eyeCatchImage = post_detail.image
        end
      end
      cache_url = "https://www.rekishoku.jp/app/post/" + @story[:id].to_s
      create_page_cache(cache_url, eyeCatchImage, @story[:title], @story[:content])
      result = @story.update(post_params)
    end
    if result
      render json: @story, status: :ok
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stories/1
  # 削除
  def destroy
    @story = Story.where(user_id: current_user.id).find(params[:id])
    @story.destroy
    head :no_content
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:title, :content, :image, :favorite_count, :status, :user_id, :quotation_url, :quotation_name, :category_id, :memo, :published_at, :is_eye_catch, :is_map)
    end

end
