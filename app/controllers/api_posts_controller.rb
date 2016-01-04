class ApiPostsController < ApplicationController

  # GET /api/posts/1
  def index
    @posts = Post.accessible_by(current_ability).joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').order(created_at: :desc)
    if current_user
      @posts = @posts.where(user_id: current_user.id)
    else
      @posts = @posts.where(status: 1)
    end

    # 検索条件の設定
    if params[:keywords]
      keywords = params[:keywords]
      for kw in keywords.split(" ")
        # タイトル&本文で検索
        @posts = @posts
          .joins(:post_details)
          .where('posts.title LIKE ? or posts.content LIKE ? or post_details.title LIKE ? or post_details.content LIKE ?', "%#{kw}%", "%#{kw}%" , "%#{kw}%", "%#{kw}%").uniq
      end
    end

    if params[:category]
      # カテゴリーで検索
      @posts = @posts.where(category_id: params[:category].to_i)
    end
    render json: @posts.page(params[:page]).per(params[:per])
  end

  # GET /api/posts/1
  def show
    @post = Post.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').find(params[:id])
    logger.debug(params[:preview])
    if params[:preview] == "true" || @post.status == 1
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
    else
      post = { "post" => "" }
      render json: post
    end
  end

  def create
    category = PostCategory.find_by(slug: params[:slug])
    @post = Post.new(post_params.merge(user_id: current_user.id, category_id: category.id))

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    if post_params[:status].blank?
      category = PostCategory.find_by(slug: params[:slug])
      post_params.merge(category_id: category.id)
    end
    if @post.update(post_params)
      render json: @post, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    head :no_content
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :image, :favorite_count, :status, :user_id, :quotation_url, :quotation_name, :category_id, :memo)
    end

end
