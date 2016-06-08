class FeaturesController < ApplicationController
    #load_and_authorize_resource
  before_action :set_feature, only: [:edit, :update, :destroy]

  # POST /posts
  # POST /posts.json
  def create
    setPublishedAt = feature_params[:published_at].split(/\D+/)
    @feature = Feature.new(feature_params.merge(published_at: Time.zone.local(setPublishedAt[0],setPublishedAt[1],setPublishedAt[2],setPublishedAt[3],setPublishedAt[4])))
    @feature.save
    redirect_to "/admin/feature"
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    setPublishedAt = feature_params[:published_at].split(/\D+/)
    @feature.update(feature_params.merge(published_at: Time.zone.local(setPublishedAt[0],setPublishedAt[1],setPublishedAt[2],setPublishedAt[3],setPublishedAt[4])))
    redirect_to "/admin/feature"
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
