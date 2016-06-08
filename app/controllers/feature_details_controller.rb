class FeatureDetailsController < ApplicationController
  #load_and_authorize_resource
#before_action :set_post, only: [:edit, :update, :destroy]

# POST /posts
# POST /posts.json
def create
  related_id = 0
  if feature_detail_params[:info_type] == "0"
    related_id = feature_detail_params[:shop_ids][2]
  elsif feature_detail_params[:info_type] == "1"
    related_id = feature_detail_params[:post_ids][2]
  else
    related_id = feature_detail_params[:external_link_ids][2]
  end
  @feature_detail = FeatureDetail.new(feature_detail_sent_params.merge(related_id: related_id))
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
    params.require(:feature_detail).permit(:title, :content, :info_type, :order, :shop_ids => [], :post_ids => [], :external_link_ids => [])
  end

  def feature_detail_sent_params
    params.require(:feature_detail).permit(:title, :content, :info_type, :order)
  end
end
