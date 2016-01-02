class ApiPostsShopsController < ApplicationController

  # POST /posts_shops
  def create
    # 削除
    id = params[:post_id]
    PostsShop.delete_all(['post_id = ?', id])
    # 新規作成の場合
    isSuccess = true
    if params[:shop_ids]
      params[:shop_ids].each_with_index do |shop_id, i|
        @posts_shop = PostsShop.new
        @posts_shop.post_id = params[:post_id]
        @posts_shop.shop_id = shop_id
        if !@posts_shop.save
          isSuccess = false
          @posts_shop_err = @posts_shop
        end
      end

      if isSuccess
        obj = {}
        render json: obj, status: :created
      else
        render json: @posts_shop_err.errors, status: :unprocessable_entity
      end

    # 作成対象がない場合
    else
      respond_to do |format|
        format.json { head :no_content }
      end
    end

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def posts_shop_params
      params.require(:posts_shop).permit(:post_id, :shop_id)
    end
end
