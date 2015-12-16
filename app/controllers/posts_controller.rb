class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :set_post, only: [:edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.accessible_by(current_ability).joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').order(created_at: :desc)
    if current_user
      @posts = @posts.where(user_id: current_user.id)
    else
      @posts = @posts.where(status: 1)
    end

    # フリーワードとカテゴリ検索を行なう
    if params[:text]
      @posts = @posts.where('title LIKE ? || content LIKE ?', params[:text],params[:text],params[:text])
    end
    if params[:category]
      @posts = @posts.where(category_id: params[:category].to_i)
    end
    render json: @posts.page(params[:page]).per(params[:per])
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').find(params[:id])
    shops = Array.new()
    # shop情報整形
    @post.shops.each do |shop|
      obj = { "shop" => shop, "categories" => shop.categories }
      shops.push(obj);
    end
    # user情報整形
    user = { "id" => @post.user.id, "username" => @post.user.username, "image" => @post.user.image.thumb }

    post = { "post" => @post, "shops" => shops, "user" => user }
    render json: post
  end

  # GET /posts/new
  # def new
  #   @post = Post.new
  # end

  # GET /posts/1/edit
  # def edit
  # end

  # POST /posts
  # POST /posts.json
  def create
    category = PostCategory.find_by(slug: params[:slug])
    @post = Post.new(post_params.merge(user_id: current_user.id, category_id: category.id))

    respond_to do |format|
      if @post.save
        format.json { render :show, status: :created, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if post_params[:status].blank?
      category = PostCategory.find_by(slug: params[:slug])
      post_params.merge(category_id: category.id)
    end
    respond_to do |format|
      if @post.update(post_params)
        format.json { render :show, status: :ok, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :image, :favorite_count, :status, :user_id, :quotation_url, :quotation_name, :category_id, :memo)
    end
end
