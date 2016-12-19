class FeatureDetailsController < ApplicationController
  load_and_authorize_resource
  before_action :set_feature_detail, only: [:edit, :update, :destroy]

  # POST /feature_detail
  # POST /feature_detail.json
  def create
    if feature_detail_params[:related_type] == ""
      @featureDetails = FeatureDetail.new(feature_detail_params.merge(related_type: nil))
    else
      @featureDetails = FeatureDetail.new(feature_detail_params)
    end
    @featureDetails.save
    redirect_to "/admin/feature_detail"
  end

  # PATCH/PUT /feature_detail/1
  # PATCH/PUT /feature_detail/1.json
  def update
    ## 公開日の設定
    if feature_detail_params[:related_type] == ""
      @featureDetails.update(feature_detail_params.merge(related_type: nil))
    else
      @featureDetails.update(feature_detail_params)
    end
    redirect_to "/admin/feature_detail"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature_detail
      @featureDetails = FeatureDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_detail_params
      params.require(:feature_detail).permit(:title, :content, :related_type, :related_id, :order, :id)
    end
end
