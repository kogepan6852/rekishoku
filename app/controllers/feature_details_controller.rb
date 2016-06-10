class FeatureDetailsController < ApplicationController
  #load_and_authorize_resource
before_action :set_feature_detail, only: [:edit, :update, :destroy]

# POST /posts
# POST /posts.json
def create
  related_id = 0
  @feature_detail = FeatureDetail.new(feature_detail_params.merge(related_id: related_id))
  @feature_detail.save
  redirect_to "/admin/feature_detail"
end

# PATCH/PUT /posts/1
# PATCH/PUT /posts/1.json
def update
  related_id = 0
  @feature_detail.update(feature_detail_params.merge(related_id: related_id))
  redirect_to "/admin/feature_detail"
end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_feature_detail
    @feature_detail = FeatureDetail.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feature_detail_params
    params.require(:feature_detail).permit(:title, :content, :related_type, :related_id, :order)
  end

  def feature_detail_check_params
    params.require(:feature_detail).permit(:is_external_link, :shop_ids => [], :post_ids => [])
  end
end
