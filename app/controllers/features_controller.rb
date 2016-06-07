class FeaturesController < ApplicationController
    #load_and_authorize_resource
  before_action :set_feature, only: [:edit, :update, :destroy]

  # POST /posts
  # POST /posts.json
  def create
    #### 来たデータが保存されていない。。
    #### それに対応する必要がある
    category = FeatureCategory.find_by(slug: params[:slug])
    @feature = Feature.new(feature_params.merge(user_id: 1, category_id: 9))
    @feature.save
    redirect_to "/admin"
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @feature.update(feature_params)
    redirect_to "/admin"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = Feature.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_params
      params.require(:feature).permit(:title, :content, :image, :status, :user_id, :category_id, :quotation_url, :quotation_name, :category_id, :feature_details_ids => [])
    end
end
