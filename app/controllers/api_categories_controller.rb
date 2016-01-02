class ApiCategoriesController < ApplicationController
  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.where(type: params[:type])
    render json: @categories
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :slug, :type)
    end
end
