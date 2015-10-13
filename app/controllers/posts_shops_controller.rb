class PostsShopsController < ApplicationController
  before_action :set_posts_shop, only: [:show, :edit, :update, :destroy]

  # GET /posts_shops
  # GET /posts_shops.json
  def index
    @posts_shops = PostsShop.where(post_id: params[:post_id])
    render json: @posts_shops
  end

  # GET /posts_shops/1
  # GET /posts_shops/1.json
  def show
  end

  # GET /posts_shops/new
  def new
    @posts_shop = PostsShop.new
  end

  # GET /posts_shops/1/edit
  def edit
  end

  # POST /posts_shops
  # POST /posts_shops.json
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

      respond_to do |format|
        if isSuccess
          format.json { render :show, status: :created }
        else
          format.json { render json: @posts_shop_err.errors, status: :unprocessable_entity }
        end
      end

    # 削除のみの場合
    else
      respond_to do |format|
        format.json { head :no_content }
      end
    end

  end

  # PATCH/PUT /posts_shops/1
  # PATCH/PUT /posts_shops/1.json
  def update
    respond_to do |format|
      if @posts_shop.update(posts_shop_params)
        format.html { redirect_to @posts_shop, notice: 'Posts shop was successfully updated.' }
        format.json { render :show, status: :ok, location: @posts_shop }
      else
        format.html { render :edit }
        format.json { render json: @posts_shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts_shops/1
  # DELETE /posts_shops/1.json
  def destroy
    @posts_shop.destroy
    respond_to do |format|
      format.html { redirect_to posts_shops_url, notice: 'Posts shop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_posts_shop
      @posts_shop = PostsShop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def posts_shop_params
      params.require(:posts_shop).permit(:post_id, :shop_id)
    end
end
