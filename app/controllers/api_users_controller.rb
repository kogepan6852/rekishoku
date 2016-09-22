class ApiUsersController < ApplicationController
  authorize_resource :class => false

  include RelatedInfo

  # GET /users
  def index
    @users = User.where('posts_count > 0').order(updated_at: :desc)
    render json: @users
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])

    # 関連する投稿の取得
    posts = @user.posts.joins(:category)
                .select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug')
                .where("status = ? and published_at <= ?", 1, Date.today)
                .order(published_at: :desc)
    newPosts = Array.new()

    posts.each do |post|
      newPosts.push(get_post_json(post));
    end

    # 関連する特集の取得
    features = Feature.joins(:category)
                .select('features.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug')
                .where("features.status = ? and features.published_at <= ?", 1, Date.today)
                .where("user_id = ?", params[:id])
                .order(published_at: :desc)
    newfeatures = Array.new()

    features.each do |feature|
      newfeatures.push(get_feature_json(feature));
    end

    user = {
      "user" =>{
        "id" => @user.id,
        "image" => @user.image,
        "username" => @user.username,
        "profile" => @user.profile },
      "posts" => newPosts,
      "features" => newfeatures}
    if current_user
      user["user"]["email"] = @user.email
      user["user"]["description"] = @user.description
      user["user"]["first_name"] = @user.first_name
      user["user"]["last_name"] = @user.last_name
    end
    render json: user
  end

  # PATCH/PUT /users/1
  def update
    @user = User.where(id: current_user.id).find(params[:id])
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :email, :username, :description, :profile, :image, :first_name, :last_name)
    end

  end
