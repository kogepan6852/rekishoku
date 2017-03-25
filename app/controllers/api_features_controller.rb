class ApiFeaturesController < ApplicationController

  include ShopInfo
  include RelatedInfo

  # POST /api/features
  # POST /api/features.json
  def index

    @features = Feature.joins(:category)
                .select('features.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug')
                .where("features.status = ? and features.published_at <= ?", 1, Time.zone.now)
                .order(published_at: :desc)

    # フリーワードで検索
    if params[:keywords]
      keywords = params[:keywords]
      for kw in keywords.gsub("　", " ").split(" ")
        # タイトル&本文で検索
        @features = @features
          .joins(:feature_details)
          .where('features.title LIKE ? or features.content LIKE ? or feature_details.title LIKE ?', "%#{kw}%" , "%#{kw}%", "%#{kw}%").uniq
      end
    end

    # カテゴリーで検索
    if params[:category]
      @features = @features.where(category_id: params[:category].to_i)
    end

    # 時代、人物、住所で検索する場合にshopsとpostsを外部結合する
    if params[:period] || params[:person] || params[:province]
      @features = @features.joins(:feature_details)
        .joins("LEFT OUTER JOIN shops ON feature_details.related_id = shops.id AND feature_details.related_type = 'Shop'")
        .joins("LEFT OUTER JOIN people_shops ON shops.id = people_shops.shop_id AND feature_details.related_type = 'Shop'")
        .joins("LEFT OUTER JOIN posts ON feature_details.related_id = posts.id AND feature_details.related_type = 'Post'")
        .joins("LEFT OUTER JOIN people_posts ON posts.id = people_posts.post_id AND feature_details.related_type = 'Post'")
    end

    # 時代、人物で検索する場合にpeopleを内部結合する
    if params[:period] || params[:person]
      # peopleを内部結合する
      @features = @features
        .joins("INNER JOIN people ON (people_shops.person_id = people.id AND feature_details.related_type = 'Shop')
                                  OR (people_posts.person_id = people.id AND feature_details.related_type = 'Post')")
    end

    # 時代で検索
    if params[:period]
      # periodsを内部結合する
      @features = @features
        .joins("INNER JOIN people_periods ON people.id = people_periods.person_id")
        .joins("INNER JOIN periods ON people_periods.period_id = periods.id")
        .where('periods.id = ?', params[:period]).uniq
    end

    # 人物で検索
    if params[:person]
      @features = @features.joins(:feature_details)
        .where('people.id = ?', params[:person]).uniq
    end

    # 都道府県検索
    if params[:province]
      @features = @features
        .joins("LEFT OUTER JOIN posts_shops ON posts.id = posts_shops.post_id")
        .joins("LEFT OUTER JOIN shops as shops2 ON posts_shops.shop_id = shops2.id")
        .where('shops.province = ? OR shops2.province = ?', params[:province], params[:province]).uniq
    end

    # ライターで検索
    if params[:writer]
      @features = @features.where("user_id = ?", params[:writer])
    end

    if params[:page] && params[:per]
      @features = @features.page(params[:page]).per(params[:per])
    end

    newFeatures = Array.new()
    @features.each do |feature|
      # json形式のデータを取得
      newFeatures.push(get_feature_json(feature));
    end
    render json: newFeatures
  end

  # PATCH/PUT /api/features/1
  # PATCH/PUT /api/features/1.json
  def show
    @feature = Feature.joins(:category).select('features.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').where("status = ?", 1).find(params[:id])

    if params[:preview] == "true" || @feature.status == 1
      # user情報整形
      user = {
        "id" => @feature.user.id,
        "username" => @feature.user.username,
        "image" => @feature.user.image.thumb }

      feature_details = Array.new()
      periods = Array.new()
      people = Array.new()
      feature_details_order = @feature.feature_details.order(:order)

      # featureに紐付いてる人物を取得する
      people = get_people(@feature)
      # featureに紐付けしている時代を取得をする
      periods = get_periods(@feature.people)

      # それぞれの詳細対応
      feature_details_order.each do |feature_detail|
        if feature_detail[:related_type] == "Shop"
          # 対応するShopの情報を取得する
          shop = Shop.joins("LEFT OUTER JOIN periods ON shops.period_id = periods.id").select('shops.*, periods.name as period_name').find(feature_detail[:related_id])
          obj = get_shop_json(shop)
        elsif feature_detail[:related_type] == "Post"
          # 対応するPostの情報を取得する
          post = Post.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').find(feature_detail[:related_id])
          obj = get_post_json(post)
        elsif feature_detail[:related_type] == "ExternalLink"
          # 対応するExternalLinkの情報を取得する
          obj = get_external_link_json(feature_detail.related)
        end

        if feature_detail[:related_type].nil?
          obj =  { "feature_detail" => feature_detail }
          feature_details.push(obj)
        else
          obj.store("feature_detail",feature_detail)
          feature_details.push(obj)
        end
      end

      # 返却用のオブジェクトを作成する
      feature = {
        "feature" => @feature,
        "feature_details" => feature_details.uniq,
        "people" => people.uniq,
        "periods" => periods.uniq,
        "user" => user }

      render json: feature
    else
      feature = { "feature" => "" }
      render json: feature
    end
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_params
      params.require(:feature).permit(:title, :content, :image, :status, :user_id, :category_id, :quotation_url, :quotation_name, :published_at, :category_id, :feature_detail_ids => [])
    end

end
