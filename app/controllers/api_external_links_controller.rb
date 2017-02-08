class ApiExternalLinksController < ApplicationController
  # GET /external_links
  def index
    @external_links = ExternalLink.all.order(id: :desc)
    external_links = Array.new()
    @external_links.each do |external_link|
      obj = {
        "id" => external_link.id,
        "name" => external_link.name
      }
      external_links.push(obj)
    end
    render json: external_links
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def external_link_params
      params.require(:external_link).permit(:id)
    end
end
