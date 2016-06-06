class FeatureDetailsController < ApplicationController
  #load_and_authorize_resource
#before_action :set_post, only: [:edit, :update, :destroy]

# POST /posts
# POST /posts.json
def create
  redirect_to "/admin"
end

# PATCH/PUT /posts/1
# PATCH/PUT /posts/1.json
def update
  redirect_to "/admin"
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
