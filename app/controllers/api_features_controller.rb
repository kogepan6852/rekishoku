class ApiFeaturesController < ApplicationController
  before_action :set_feature, only: [:edit, :show, :destroy]

  # POST /posts
  # POST /posts.json
  def index
    feature = Feature.order(created_at: :desc)
    # カテゴリーで検索
    if params[:category]
      feature = feature.where(category_id: params[:category].to_i)
    end
    render json: feature
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def show
    feature = Feature.order(created_at: :desc)
    # カテゴリーで検索
    if params[:category]
      feature = feature.where(category_id: params[:category].to_i)
    end
    render json: feature
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
