class ApiFeaturesController < ApplicationController
  before_action :set_feature, only: [:edit, :show, :destroy]

  # POST /posts
  # POST /posts.json
  def index
    ###### copy
    @features = Feature.joins(:category).select('features.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').where("status = ? and published_at <= ?", true, Date.today).order(published_at: :desc)
    # フリーワードで検索
    if params[:keywords]
      keywords = params[:keywords]
      for kw in keywords.split(" ")
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

    # 時代で検索
    if params[:period]
      person = Person.select('distinct people.id').joins(:periods).joins(:feature_details)
        .where('periods.id' => params[:period])
      @features = @features.joins(:people).where('people.id' => person).uniq
    end

    # 人物で検索
    if params[:person]
      @features = @features.joins(:people).where('people.id' => params[:person]).uniq
    end

    # 人物で検索
    if params[:province]
      @features = @features.joins(:shops).where('shops.province' => params[:province]).uniq
    end

    newFeatures = Array.new()
    setFature = Array.new()
    @features.page(params[:page]).per(params[:per]).each do |feature|
      feature_details = FeatureDetail.where('feature_id = ? ', feature[:id])
      feature_details.page(params[:page]).per(params[:per]).each do |feature_detail|
        if feature_detail[:related_type] == "Shop"
            periods = Person.select('periods.id').joins(:shops).joins(:periods)
              .where('shops.id = ? ', feature_detail[:related_id])
            people = Person.joins(:shops).joins(:periods).where('shops.id = ? ', feature_detail[:related_id])
            logger.debug("今日もいい天気！")
        elsif feature[:features_details_related_type] == "Post"
          features = Post.find(feature[:features_details_related_id])
        elsif feature[:features_details_related_type] == "ExternalLink"
          features = ExternalLink.find(feature[:features_details_related_id])
        end
        # 返却用のオブジェクトを作成する
        obj = { "feature_details" => feature_detail,
                "people" => people.uniq,
                "periods" => periods.uniq
              }

        newFeatures.push(obj);
      end
      fatureData = {
              "feature" => feature,
              "feature_details" => newFeatures,
            }

      setFature.push(fatureData);

    end

    render json: setFature
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def show
    @features = Feature.joins(:feature_details).joins(:category).select('features.*, feature_details.id as features_details_id, feature_details.related_type as features_details_related_type, feature_details.related_id as features_details_related_id, feature_details.order as features_details_order,categories.id as category_id, categories.name as category_name, categories.slug as category_slug').where("status = ? and published_at <= ?", 1, Date.today).find(params[:id]).order(:order)
    logger.debug(params[:preview])
    if params[:preview] == "true" || @features.status == 1 && @features.published_at <= Date.today
      # user情報整形
      user = {
        "id" => @features.user.id,
        "username" => @features.user.username,
        "image" => @features.user.image.thumb }

      # shopsに紐付けしている時代を取得をする
      periods = Person.select('periods.id').joins(:shops).joins(:periods)
          .where('shops.id = ? ', feature[:features_details_related_id])
      # shopsに紐付いてる人物を取得する
      people = Person.joins(:shops).joins(:periods).where('shops.id = ? ', feature[:features_details_related_id])

      # 紐付けしている
      shops = Shop.where('shops.id = ? ', feature[:features_details_related_id])
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

      feature = {
        "feature" => @feature,
        "shops" => shops,
        "user" => user,
        "people" => people,
        "periods" => postPeriods.uniq, }
      render json: post
    else
      feature = { "feature" => "" }
      render json: feature
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = Feature.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_params
      params.require(:feature).permit(:title, :content, :image, :status, :user_id, :category_id, :quotation_url, :quotation_name, :published_at, :category_id, :feature_detail_ids => [])
    end
end
