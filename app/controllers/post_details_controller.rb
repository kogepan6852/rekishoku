class PostDetailsController < ApplicationController
  before_action :set_post_detail, only: [:edit, :update]

  # GET /post_details
  # GET /post_details.json
  def index
    @post_details = PostDetail.all
    render json: @post_details
  end

  # GET /post_details/1
  # GET /post_details/1.json
  def show
    @post_details = PostDetail.accessible_by(current_ability).where(post_id: params[:id]).order(id: :asc)
    render json: @post_details
  end

  # GET /post_details/new
  def new
    @post_detail = PostDetail.new
  end

  # GET /post_details/1/edit
  def edit
  end

  # POST /post_details
  # POST /post_details.json
  def create
    isSuccess = true
    post_details = params[:post_details]
    params[:post_details].each_with_index do |post_detail, i|
      @post_detail = PostDetail.new
      @post_detail.post_id = post_detail['post_id']
      @post_detail.title = post_detail['title']
      @post_detail.image = post_detail['image']
      @post_detail.content = post_detail['content']
      @post_detail.quotation_url = post_detail['quotation_url']
      @post_detail.quotation_name = post_detail['quotation_name']

      if !@post_detail.save
        isSuccess = false
      end
    end

    respond_to do |format|
      if isSuccess
        format.html { redirect_to @post_detail, notice: 'Post detail was successfully created.' }
        format.json { render :show, status: :created, location: @post_detail }
      else
        format.html { render :new }
        format.json { render json: @post_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /post_details/1
  # PATCH/PUT /post_details/1.json
  def update
    respond_to do |format|
      if @post_detail.update(post_detail_params)
        format.html { redirect_to @post_detail, notice: 'Post detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @post_detail }
      else
        format.html { render :edit }
        format.json { render json: @post_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /post_details/1
  # DELETE /post_details/1.json
  def destroy
    id = params[:id]
    PostDetail.accessible_by(current_ability).destroy_all(['post_id = ?', id])
    respond_to do |format|
      format.html { redirect_to post_details_url, notice: 'Post detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post_detail
      @post_detail = PostDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_detail_params
      params.require(:post_detail).permit(:post_id, :title, :image, :content, :quotation_url, :quotation_name)
    end
end
