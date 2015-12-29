class ApiPostController < ApplicationController
  # GET /api_post/posts/1
  # GET /api_post/posts/1.json
  def posts
    if params[:id]
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
    else
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
  end


  def post_details
    @post_details = PostDetail.accessible_by(current_ability).where(post_id: params[:id]).order(id: :asc)
    render json: @post_details
  end


    def categories
      if params[:type]
        @categories = Category.where(type: params[:type])
      else
        @categories = Category.all
      end
      render json:@categories
    end


end
