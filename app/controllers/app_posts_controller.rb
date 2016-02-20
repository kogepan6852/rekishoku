class AppPostsController < ApplicationController

  # GET /api/posts/1
  # 詳細データ表示
  def show
    @post = Post.find(params[:id])

    keywords = Array.new
    @post.people.each do |person|
      keywords.push(person.name)
    end
    @post.shops.each do |shop|
      keywords.push(shop.name)
    end

    set_meta_tags title: @post.title
    set_meta_tags description: @post.content.gsub(/(\r\n|\r|\n|\f)/,"")
    set_meta_tags keywords: keywords.join(",")

    if params[:_escaped_fragment_].nil?

      logger.debug(request.path)
      redirect_to("/#" + request.path)
    end

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :image, :favorite_count, :status, :user_id, :quotation_url, :quotation_name, :category_id, :memo, :published_at)
    end

end
