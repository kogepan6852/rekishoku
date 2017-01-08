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

    user = {
      "id" => @user.id,
      "image" => @user.image,
      "username" => @user.username,
      "profile" => @user.profile
    }

    if current_user
      user["email"] = @user.email
      user["description"] = @user.description
      user["first_name"] = @user.first_name
      user["last_name"] = @user.last_name
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
