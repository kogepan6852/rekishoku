class ApiPeoplePostsController < ApplicationController
  authorize_resource :class => false

  # POST /api/people_posts
  def create
    # 削除
    id = params[:post_id]
    PeoplePost.delete_all(['post_id = ?', id])

    # 新規作成
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

      if isSuccess
        render json: @people_post, status: :created
      else
        render json: @people_post_err.errors, status: :unprocessable_entity
      end

    # 作成対象がない場合
    else
      respond_to do |format|
        format.json { head :no_content }
      end
    end

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def people_post_params
      params.require(:people_post).permit(:person_id, :post_id)
    end
end
