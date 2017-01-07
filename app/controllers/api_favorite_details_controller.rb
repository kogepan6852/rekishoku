class ApiFavoriteDetailsController < ApplicationController
  before_action :set_favorite_detail, only: [:update, :destroy]

  # POST /api/favorites_detail
  # POST /api/favorites_detail.json
  def create
    if favorite_detail_params[:related_type] == ""
      @favorite_details = FavoriteDetail.new(favorite_detail_params.merge(related_type: nil))
    else
      @favorite_details = FavoriteDetail.new(favorite_detail_params)
    end

    if @favorite_details.save
      render json: @favorite_details, status: :created
    else
      render json: @favorite_details.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/favorites_detail/1
  # PATCH/PUT /api/favorites_detail/1.json
  def update
    
    if favorite_detail_params[:related_type] == ""
      result = @favorite_details.update(favorite_detail_params.merge(related_type: nil))
    else
      result = @favorite_details.update(favorite_detail_params)
    end

    if result
      render json: @favorite_details, status: :ok
    else
      render json: @favorite_details.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/favorites_detail/1
  # 削除
  def destroy
    @favorite_details.destroy
    head :no_content
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite_detail
      @favorite_details = FavoriteDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_detail_params
      params.require(:api_favorite_detail).permit(:favorite_id, :related_type, :related_id, :id)
    end
end
