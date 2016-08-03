class ExternalLinksController < ApplicationController
  load_and_authorize_resource
  before_action :set_external_link, only: [:update]
  include ApiGeocoder

  # POST /external_links
  # POST /external_links.json
  def create
    # 住所から緯度経度を求める
    addressPlace = get_geocoder(external_link_params[:province]+external_link_params[:city]+external_link_params[:address1]);
    # 緯度経度を代入する
    @external_link = ExternalLink.new(external_link_params.merge(latitude: addressPlace[0], longitude: addressPlace[1]))
    @external_link.save
    redirect_to "/admin/external_link"
  end

  # PATCH/PUT /external_links/1
  # PATCH/PUT /external_links/1.json
  def update
    # 住所から緯度経度を求める
    addressPlace = get_geocoder(external_link_params[:province]+external_link_params[:city]+external_link_params[:address1]);
    # 緯度経度を代入する
    @external_link.update(external_link_params.merge(latitude: addressPlace[0], longitude: addressPlace[1]))
    redirect_to "/admin/external_link"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_link
      @external_link = ExternalLink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def external_link_params
      params.require(:external_link).permit(:name, :content, :url, :image, :quotation_url, :quotation_name, :post_quotation_url, :post_quotation_name, :province, :city, :address1, :address2, :latitude, :longitude, :person_ids => [])
    end

end
