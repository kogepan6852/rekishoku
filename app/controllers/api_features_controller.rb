class ApiFeaturesController < ApplicationController
  before_action :set_feature, only: [:edit, :show, :destroy]

  include ShopInfo
  include RelatedInfo

  # POST /api/features
  # POST /api/features.json
  def index

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
    periods = Array.new()
    people = Array.new()

    @features.page(params[:page]).per(params[:per]).each do |feature|
      feature_details = FeatureDetail.where('feature_id = ? ', feature[:id])
      feature_details.each do |feature_detail|
        if feature_detail[:related_type] == "Shop"
            periods += Person.select('periods.id').joins(:shops).joins(:periods)
              .where('shops.id = ? ', feature_detail[:related_id])
            people += Person.joins(:shops).joins(:periods).where('shops.id = ? ', feature_detail[:related_id])
        elsif feature_detail[:related_type] == "Post"
          periods += Person.select('periods.id').joins(:posts).joins(:periods)
            .where('posts.id = ? ', feature_detail[:related_id])
          people += Person.joins(:posts).joins(:periods).where('posts.id = ? ', feature_detail[:related_id])
        elsif feature_detail[:related_type] == "ExternalLink"

        end
      end

      fatureData = {
              "feature" => feature,
              "people" => people.uniq,
              "periods" => periods.uniq
            }
      newFeatures.push(fatureData);
    end

    render json: newFeatures
  end

  # PATCH/PUT /api/features/1
  # PATCH/PUT /api/features/1.json
  def show
    @feature = Feature.joins(:category).select('features.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').where("status = ? and published_at <= ?", true, Date.today).find(params[:id])

    if params[:preview] == "true" || @feature.status == true && @feature.published_at <= Date.today
      # user情報整形
      user = {
        "id" => @feature.user.id,
        "username" => @feature.user.username,
        "image" => @feature.user.image.thumb }

      feature_details = Array.new()
      # 紐付けしている
      feature_details_id = FeatureDetail.where('feature_id = ? ', @feature[:id])
      feature_details_id.each do |feature_detail|
        # 人に紐付く時代を全て抽出する
        shop = Shop.find(feature_detail[:related_id])
        # shopsに紐付けしている時代を取得をする
        periods = Person.select('periods.id').joins(:shops).joins(:periods)
            .where('shops.id = ? ', feature_detail[:related_id])
        # shopsに紐付いてる人物を取得する
        people = Person.joins(:shops).joins(:periods).where('shops.id = ? ', feature_detail[:related_id])

        # 歴食度の設定
        rating = cal_rating(shop)
        # 価格帯の取得
        price = get_price(shop)

        obj = { "feature_detail" => feature_detail,
                "shop" => shop,
                "categories" => shop.categories,
                "people" => shop.people,
                "periods" => periods,
                "rating" => rating,
                "price" => price
              }
        feature_details.push(obj);
      end

      feature = {
        "feature" => @feature,
        "feature_details" => feature_details.uniq,
        "user" => user }
      render json: feature
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
