class PostsShopsController < ApplicationController
  load_and_authorize_resource
  before_action :set_posts_shop, only: [:show, :edit, :update, :destroy]

  # GET /posts_shops
  # GET /posts_shops.json
  def index
    @posts_shops = PostsShop.all
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
