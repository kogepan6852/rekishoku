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

    # 都道府県検索
    if params[:province]
      @features = @features.joins(:shops).where('shops.province' => params[:province]).uniq
    end

    newFeatures = Array.new()
    periods = Array.new()
    people = Array.new()
    @shops = Shop.joins(:feature_details)
    @posts = Post.joins(:feature_details)
    @extrnal_links = ExternalLink.joins(:feature_details)

    if params[:page] && params[:per]
      @features.page(params[:page]).per(params[:per]).each do |feature|
        type = feature[:feature_details_type]
        if type == 1 || type == 4 || type == 6 || type == 7
          shops = @shops.where('feature_id = ? ', feature[:id])
          people += gets_people(shops)
        end
        if type == 2 || type == 4 || type == 5 || type == 7
          posts = @posts.where('feature_id = ? ', feature[:id])
          people += gets_people(posts)
        end
        if type == 3 || type == 5 || type == 6 || type == 7
          extrnal_links = @extrnal_links.where('feature_id = ? ', feature[:id])
          people += gets_people(posts)
        end
        periods += get_periods(people)

        fatureData = {
                "feature" => feature,
                "people" => people.uniq,
                "periods" => periods.uniq
              }
              newFeatures.push(fatureData);
      end
      render json: newFeatures
    end

    render json: @features
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
      @shops = Shop.all
      @posts = Post.all
      @extrnal_links = ExternalLink.all

      # それぞれの詳細対応
      feature_details_id = FeatureDetail.where('feature_id = ? ', @feature[:id])
      feature_details_id.each do |feature_detail|
        if feature_detail[:related_type] == "Shop"
          # 対応するShopを取得する
          shop = @shops.find(feature_detail[:related_id])
          obj = shop_show(shop)
        elsif feature_detail[:related_type] == "Post"
          # 対応するPostを取得する
          post = @posts.find(feature_detail[:related_id])
          obj = post_show(post)
        elsif feature_detail[:related_type] == "ExternalLink"

        end
        obj.store("feature_detail",feature_detail)
        feature_details.push(obj)
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
