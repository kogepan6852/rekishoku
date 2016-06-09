class FeatureDetailsController < ApplicationController
  #load_and_authorize_resource
#before_action :set_post, only: [:edit, :update, :destroy]

# POST /posts
# POST /posts.json
def create
  related_id = 0
  if feature_detail_check_params[:shop_ids].size == 3
    related_id = feature_detail_params[:shop_ids][2]
  elsif feature_detail_check_params[:post_ids].count == 3
    related_id = feature_detail_params[:post_ids][2]
  end

  if feature_detail_check_params[:is_external_link]
    @feature_detail = FeatureDetail.new(feature_detail_external_link_params.merge(related_id: related_id))
  else
    @feature_detail = FeatureDetail.new(feature_detail_params.merge(related_id: related_id))
  end
  @feature_detail.save
  redirect_to "/admin/feature_detail"
end

# PATCH/PUT /posts/1
# PATCH/PUT /posts/1.json
def update
  @feature_detail.update(feature_detail_sent_params.merge(related_id: 1))
  redirect_to "/admin/feature_detail"
end

# DELETE /api/post_details/1
def destroy
  id = params[:id]
  FeatureDetail.accessible_by(current_ability).destroy_all(['feature_id = ?', id])
  head :no_content
end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_feature_detail
    @feature_detail = FeatureDetail.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feature_detail_params
    params.require(:feature_detail).permit(:title, :content, :info_type, :order, :is_external_link)
  end

  def feature_detail_check_params
    params.require(:feature_detail).permit(:is_external_link, :shop_ids => [], :post_ids => [])
  end

  def feature_detail_external_link_params
    params.require(:feature_detail).permit(:title, :content, :info_type, :order, :is_external_link, :external_link_title, :content, :image, :quotation_url, :quotation_name)
  end
end
