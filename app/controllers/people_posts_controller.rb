class PeoplePostsController < ApplicationController
  before_action :set_people_post, only: [:show, :edit, :update, :destroy]

  # GET /people_posts
  # GET /people_posts.json
  def index
    @people_posts = PeoplePost.where(post_id: params[:post_id])
    render json: @people_posts
  end

  # GET /people_posts/1
  # GET /people_posts/1.json
  def show
  end

  # GET /people_posts/new
  def new
    @people_post = PeoplePost.new
  end

  # GET /people_posts/1/edit
  def edit
  end

  # POST /people_posts
  # POST /people_posts.json
  def create
    # 削除
    id = params[:post_id]
    PeoplePost.delete_all(['post_id = ?', id])
    # 新規作成の場合
    isSuccess = true
    if params[:person_ids]
      params[:person_ids].each_with_index do |person_id, i|
        @people_post = PeoplePost.new
        @people_post.post_id = params[:post_id]
        @people_post.person_id = person_id
        if !@people_post.save
          isSuccess = false
          @people_post_err = @people_post
        end
      end

      respond_to do |format|
        if isSuccess
          format.json { render :show, status: :created }
        else
          format.json { render json: @people_post_err.errors, status: :unprocessable_entity }
        end
      end

    # 削除のみの場合
    else
      respond_to do |format|
        format.json { head :no_content }
      end
    end

  end

  # PATCH/PUT /people_posts/1
  # PATCH/PUT /people_posts/1.json
  def update
    respond_to do |format|
      if @people_post.update(people_post_params)
        format.html { redirect_to @people_post, notice: 'People post was successfully updated.' }
        format.json { render :show, status: :ok, location: @people_post }
      else
        format.html { render :edit }
        format.json { render json: @people_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people_posts/1
  # DELETE /people_posts/1.json
  def destroy
    @people_post.destroy
    respond_to do |format|
      format.html { redirect_to people_posts_url, notice: 'People post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_people_post
      @people_post = PeoplePost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def people_post_params
      params.require(:people_post).permit(:person_id, :post_id)
    end
end
