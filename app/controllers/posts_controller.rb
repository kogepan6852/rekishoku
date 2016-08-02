class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :set_post, only: [:edit, :update, :destroy]

  require 'net/http'
  include Prerender

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  # def show
  # end


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
    setPublishedAt = post_time_params[:published_at].split(/\D+/)
    @post = Post.new(post_params.merge(published_at: Time.zone.local(setPublishedAt[0],setPublishedAt[1],setPublishedAt[2],setPublishedAt[3],setPublishedAt[4])))
    @post.save
    Net::HTTP.get_response(URI.parse(api_url("post",@post[:id])))
    redirect_to "/admin/post"
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    setPublishedAt = post_time_params[:published_at].split(/\D+/)
    @post.update(post_params.merge(published_at: Time.zone.local(setPublishedAt[0],setPublishedAt[1],setPublishedAt[2],setPublishedAt[3],setPublishedAt[4])))
    Net::HTTP.get_response(URI.parse(api_url("post",@post[:id])))
    redirect_to "/admin/post"
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
      params.require(:post).permit(:title, :content, :image, :favorite_count, :status, :user_id, :quotation_url, :quotation_name, :category_id, :memo, :person_ids => [])
    end

    def post_time_params
      params.require(:post).permit(:published_at)
    end
end
