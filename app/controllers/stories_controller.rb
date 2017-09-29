class StoriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_post, only: [:edit, :update, :destroy]

  # GET /stories
  # GET /stories.json
  def index
    @posts = Story.all
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

  # POST /stories
  # POST /stories.json
  def create
    if post_time_params[:published_at] != ""
      setPublishedAt = post_time_params[:published_at].split(/\D+/)
      @post = Story.new(post_params.merge(published_at: Time.zone.local(setPublishedAt[0],setPublishedAt[1],setPublishedAt[2],setPublishedAt[3],setPublishedAt[4])))
    else
      @post = Story.new(post_params)
    end

    @post.save
    redirect_to "/admin/story"
  end

  # PATCH/PUT /stories/1
  # PATCH/PUT /stories/1.json
  def update
    if post_time_params[:published_at] != ""
      setPublishedAt = post_time_params[:published_at].split(/\D+/)
      @post.update(post_params.merge(published_at: Time.zone.local(setPublishedAt[0],setPublishedAt[1],setPublishedAt[2],setPublishedAt[3],setPublishedAt[4])))
    else
      @post.update(post_params)
    end
    redirect_to "/admin/story"
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
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
      @post = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:story).permit(:title, :content, :image, :favorite_count, :status, :user_id, :quotation_url, :quotation_name, :category_id, :memo, :shop_ids => [], :person_ids => [])
    end

    def post_time_params
      params.require(:story).permit(:published_at)
    end
end
