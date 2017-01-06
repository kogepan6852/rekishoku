class ApiFavoritesController < ApplicationController

  include ShopInfo
  include RelatedInfo

  # POST /api/favorites
  # POST /api/favorites.json
  def index

    @favorites = Favorite.order(:order)
    newFavorites = Array.new()
    # user_idで検索
    if params[:user_id]
      @favorites = @favorites.where(user_id: params[:user_id].to_i)
    end
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

  # PATCH/PUT /api/features/1
  # PATCH/PUT /api/features/1.json
  def show
    @favorite = Favorite.order(:order).find(params[:id])

      favorite_details = Array.new()
      favorite_details_order = FavoriteDetail.where(favorite_id: @favorite[:id])
      p("---------------------------")
      p(favorite_details_order)
      p("---------------------------")
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
          # 対応するExternalLinkの情報を取得する
          obj = get_feature_json(favorite_detail.related)
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


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_params
      params.require(:favorite).permit(:file_name, :user_id, :order, :id)
    end

end
