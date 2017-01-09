class ApiFavoritesController < ApplicationController
  authorize_resource :class => false

  include ShopInfo
  include RelatedInfo

  # POST /api/favorites
  # POST /api/favorites.json
  def index

    @favorites = Favorite.where(user_id: current_user.id).order(:order)
    newFavorites = Array.new()
    if params[:page] && params[:per]
      @favorites.page(params[:page]).per(params[:per]).each do |favorite|
        # json形式のデータを取得
        newFavorites.push(get_favorite_json(favorite))
      end
      render json: newFavorites
    else
      render json: @favorites
    end

  end

  # GET /api/features/1
  # GET /api/features/1.json
  def show
    @favorite = Favorite.where(user_id: current_user.id).order(:order).find(params[:id])

      favorite_details = Array.new()
      favorite_details_order = FavoriteDetail.where(favorite_id: @favorite[:id], is_delete: false)

      # それぞれの詳細対応
      favorite_details_order.each do |favorite_detail|
        if favorite_detail[:related_type] == "Shop"
          # 対応するShopの情報を取得する
          obj = get_shop_json(favorite_detail.related)
        elsif favorite_detail[:related_type] == "Post"
          # 対応するPostの情報を取得する
          post = Post.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').find(favorite_detail[:related_id])
          obj = get_post_json(post)
        elsif favorite_detail[:related_type] == "Feature"
          # 対応するFeatureの情報を取得する
          feature = Feature.joins(:category).select('features.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').find(favorite_detail[:related_id])
          obj = get_feature_json(feature)
        end
        obj.store("favorite_detail",favorite_detail)
        favorite_details.push(obj)
      end


      # 返却用のオブジェクトを作成する
      feature = {
        "favorite" => @favorite,
        "favorite_detail" => favorite_details.uniq,
      }

      render json: feature
  end

  # POST /api/favorites
  # 新規作成
  def create
    @favorite = Favorite.new(favorite_params)
    if @favorite.save
      render json: @favorite, status: :created
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/favorites/1
  # 更新
  def update
    @favorite = Favorite.find(params[:id])
    result = @favorite.update(favorite_params)
    if result
      render json: @favorite, status: :ok
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/favorites/1
  # 削除
  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy

    @favorite_details = FavoriteDetail.where(favorite_id: params[:id])
    @favorite_details.each do |favorite_detail|
      favorite_detail.destroy
    end
    head :no_content
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_params
      params.require(:favorite).permit(:name, :order, :user_id)
    end

end
