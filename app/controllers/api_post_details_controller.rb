class ApiPostDetailsController < ApplicationController

  # GET /api/post_details/1
  def index
    @post_details = PostDetail.accessible_by(current_ability).where(post_id: params[:id]).order(id: :asc)
    render json: @post_details
  end

  # POST /api/post_details
  def create
    isSuccess = true
    post_details = params[:post_details]
    params[:post_details].each_with_index do |post_detail, i|
      if post_detail['id']
        # 更新処理
        @post_detail = PostDetail.find(post_detail['id'])
      else
        # 新規作成処理
        @post_detail = PostDetail.new
      end

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

    if isSuccess
      obj = {}
      render json: obj, status: :created
    else
      render json: @post_detail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/post_details/1
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

  # DELETE /api/post_details/1
  def destroy
    id = params[:id]
    PostDetail.accessible_by(current_ability).destroy_all(['post_id = ?', id])
    respond_to do |format|
      format.html { redirect_to post_details_url, notice: 'Post detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def post_detail_params
      params.require(:post_detail).permit(:post_id, :title, :image, :content, :quotation_url, :quotation_name)
    end

end
