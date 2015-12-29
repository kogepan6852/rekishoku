class ApiPostController < ApplicationController

  # GET /api/posts/1
  # GET /api/posts/1.json
  def posts
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

    def categories
      if params[:type]
        @categories = Category.where(type: params[:type])
      else
        @categories = Category.all
      end
      render json:@categories
    end


end
