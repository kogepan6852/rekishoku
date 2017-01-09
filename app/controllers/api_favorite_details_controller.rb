class ApiFavoriteDetailsController < ApplicationController
  authorize_resource :class => false
  before_action :set_favorite_detail, only: [:update, :destroy]

  # GET /api/favorites_detail
  # GET /api/favorites_detail.json
  def index
    @favorite_details = FavoriteDetail
      .joins(:favorite)
      .where(related_type: params[:favorite_detail][:related_type], related_id: params[:favorite_detail][:related_id], is_delete: false)
      .where("favorites.user_id = ?", current_user.id)
    
    # related_idで検索
    if params[:favorite_detail][:related_type] && params[:favorite_detail][:related_id]
      @favorite_details = @favorite_details.where(related_type: params[:favorite_detail][:related_type], related_id: params[:favorite_detail][:related_id], is_delete: false).first
    end

    render json: @favorite_details
  end

  # POST /api/favorites_detail
  # POST /api/favorites_detail.json
  def create
    @favorite_details = FavoriteDetail.where(favorite_id: params[:favorite_detail][:favorite_id], related_type: params[:favorite_detail][:related_type], related_id: params[:favorite_detail][:related_id]).first

    # データが存在しない場合は新規作成
    unless @favorite_details
      @favorite_details = FavoriteDetail.find_or_initialize_by(
        favorite_id: params[:favorite_detail][:favorite_id],
        related_type: params[:favorite_detail][:related_type],
        related_id: params[:favorite_detail][:related_id]
      )
    end

    if params[:favorite_detail][:is_delete]
      @favorite_details.is_delete = params[:favorite_detail][:is_delete]
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
    if @favorite_details.update(favorite_detail_params)
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
      params.require(:favorite_detail).permit(:favorite_id, :related_type, :related_id, :id, :is_delete)
    end
end
