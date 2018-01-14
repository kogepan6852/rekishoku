class StoryRelationsController < ApplicationController
  before_action :set_story_detail, only: [:edit, :update]

  # GET /story_details
  # GET /story_details.json
  def index
    @story_details = StoryDetail.all
    render json: @story_details
  end

  # GET /story_details/1
  # GET /story_details/1.json
  def show
    @story_details = StoryDetail.accessible_by(current_ability).where(story_id: params[:id]).order(id: :asc)
    render json: @story_details
  end

  # GET /story_details/new
  def new
    @story_detail = StoryDetail.new
  end

  # GET /story_details/1/edit
  def edit
  end

  # story /story_details
  # story /story_details.json
  def create
    isSuccess = true
    story_details = params[:story_details]
    params[:story_details].each_with_index do |story_detail, i|
      if story_detail['id']
        # 更新処理
        @story_detail = StoryDetail.find(story_detail['id'])
      else
        # 新規作成処理
        @story_detail = StoryDetail.new
      end

      @story_detail.story_id = story_detail['story_id']
      @story_detail.title = story_detail['title']
      @story_detail.image = story_detail['image']
      @story_detail.content = story_detail['content']
      @story_detail.quotation_url = story_detail['quotation_url']
      @story_detail.quotation_name = story_detail['quotation_name']
      if !@story_detail.save
        isSuccess = false
      end

    end

    respond_to do |format|
      if isSuccess
        format.html { redirect_to @story_detail, notice: 'story detail was successfully created.' }
        format.json { render :show, status: :created, location: @story_detail }
      else
        format.html { render :new }
        format.json { render json: @story_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_details/1
  # PATCH/PUT /story_details/1.json
  def update

    if story_detail_params[:is_eye_catch]
      story_details = StoryDetail.where(params[:story_id])
      story_details.each do |story_detail|
        story_detail.update(is_eye_catch: false)
      end
    end
    @story_detail.update(story_detail_params)
    redirect_to "/admin/story_detail"
  end

  # DELETE /story_details/1
  # DELETE /story_details/1.json
  def destroy
    id = params[:id]
    StoryDetail.accessible_by(current_ability).destroy_all(['story_id = ?', id])
    respond_to do |format|
      format.html { redirect_to story_details_url, notice: 'story detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_detail
      @story_detail = StoryDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_detail_params
      params.require(:story_detail).permit(:story_id, :title, :image, :content, :quotation_url, :quotation_name, :is_eye_catch)
    end
end
