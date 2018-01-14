class ApiPostsShopsController < ApplicationController
  authorize_resource :class => false

  # POST /posts_shops
  def create
    # 削除
    id = params[:story_id]
    StoriesShop.delete_all(['post_id = ?', id])
    # 新規作成の場合
    isSuccess = true
    if params[:shop_ids]
      params[:shop_ids].each_with_index do |shop_id, i|
        @stories_shop = StoriesShop.new
        @stories_shop.post_id = params[:post_id]
        @stories_shop.shop_id = shop_id
        if !@stories_shop.save
          isSuccess = false
          @stories_shop_err = @stories_shop
        end
      end

      if isSuccess
        render json: @stories_shop, status: :created
      else
        render json: @stories_shop_err.errors, status: :unprocessable_entity
      end

    # 作成対象がない場合
    else
      head :no_content
    end

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def posts_shop_params
      params.require(:stories_shop).permit(:story_id, :shop_id)
    end
end
