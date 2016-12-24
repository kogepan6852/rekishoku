class FeaturesController < ApplicationController
  load_and_authorize_resource
  before_action :set_feature, only: [:edit, :update, :destroy]

  include Prerender

  # POST /feature
  # POST /feature.json
  def create

    if feature_time_params[:published_at] != ""
      setPublishedAt = feature_time_params[:published_at].split(/\D+/)
      @feature = Feature.new(feature_params.merge(published_at: Time.zone.local(setPublishedAt[0],setPublishedAt[1],setPublishedAt[2],setPublishedAt[3],setPublishedAt[4])))
    else
      @feature = Feature.new(feature_params)
    end
    @feature.save
    cache_url = "https://www.rekishoku.jp/app/feature/" + @feature[:id].to_s
    create_page_cache(cache_url, @feature[:image], @feature[:title], @feature[:content])
    redirect_to "/admin/feature"
  end

  # PATCH/PUT /feature/1
  # PATCH/PUT /feature/1.json
  def update
    ## 公開日の設定
    if feature_time_params[:published_at] != ""
      setPublishedAt = feature_time_params[:published_at].split(/\D+/)
      @feature.update(feature_params.merge(published_at: Time.zone.local(setPublishedAt[0],setPublishedAt[1],setPublishedAt[2],setPublishedAt[3],setPublishedAt[4])))
    else
      @feature.update(feature_params)
    end
    redirect_to "/admin/feature"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = Feature.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_params
      params.require(:feature).permit(:title, :content, :image, :status, :user_id, :quotation_url, :quotation_name, :is_map, :feature_details_type, :status, :category_id, :feature_detail_ids => [], :person_ids => [])
    end

    def feature_time_params
      params.require(:feature).permit(:published_at)
    end
end
