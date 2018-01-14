class StoriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_story, only: [:edit, :update, :destroy]

  # GET /stories
  # GET /stories.json
  def index
    @posts = Story.all
  end

  # GET /posts/1
  # GET /posts/1.json
  # def show
  # end


  # POST /stories
  # POST /stories.json
  def create
    if story_time_params[:published_at] != ""
      setPublishedAt = story_time_params[:published_at].split(/\D+/)
      print(setPublishedAt)
      @story = Story.new(story_params.merge(published_at: Time.zone.local(setPublishedAt[0],setPublishedAt[1],setPublishedAt[2],setPublishedAt[3],setPublishedAt[4])))
    else
      @story = Story.new(story_params)
    end

    @story.save
    redirect_to "/admin/story"
  end

  # PATCH/PUT /stories/1
  # PATCH/PUT /stories/1.json
  def update
    if story_time_params[:published_at] != ""
      setPublishedAt = story_time_params[:published_at].split(/\D+/)
      @story.update(story_params.merge(published_at: Time.zone.local(setPublishedAt[0],setPublishedAt[1],setPublishedAt[2],setPublishedAt[3],setPublishedAt[4])))
    else
      @story.update(story_params)
    end
    redirect_to "/admin/story"
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:title, :content, :image, :favorite_count, :status, :user_id, :image_quotation_url, :image_quotation_name, :post_quotation_url, :post_quotation_name,
       :category_id, :memo, :published_at, :is_eye_catch, :is_map, :period_id, :person_ids => [], :shop_ids => [], :story_detail_ids => [])
    end

    def story_time_params
      params.require(:story).permit(:published_at)
    end
end
