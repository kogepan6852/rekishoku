class ApiPostDetailsController < ApplicationController
  authorize_resource :class => false

  include ShopInfo
  include RelatedInfo

  # GET /api/post_details/1
  def index
    post_details = PostDetail.where(post_id: params[:id]).order(:order, id: :asc)

    # それぞれの詳細対応
    rtnPostDetails = Array.new()
    post_details.each do |post_detail|
      obj = {}

      if post_detail[:related_type] == "Shop"
        
        # 対応するShopの情報を取得する
        shop = Shop.joins("LEFT OUTER JOIN periods ON shops.period_id = periods.id").select('shops.*, periods.name as period_name').find(post_detail[:related_id])
        
        obj = get_shop_json(shop)
        # detail["shop"] = obj
      elsif post_detail[:related_type] == "Post"
        
        # 対応するPostの情報を取得する
        post = Post.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').find(post_detail[:related_id])
        
        obj = get_post_json(post)
        # detail["post"] = obj
      elsif post_detail[:related_type] == "ExternalLink"
        
        # 対応するExternalLinkの情報を取得する
        obj = get_external_link_json(post_detail.related)
        # detail["external_link"] = obj

      end

      obj["id"] = post_detail.id
      obj["title"] = post_detail.title
      obj["content"] = post_detail.content
      obj["image"] = post_detail.image
      obj["quotation_url"] = post_detail.quotation_url
      obj["quotation_name"] = post_detail.quotation_name
      obj["is_eye_catch"] = post_detail.is_eye_catch
      obj["related_type"] = post_detail.related_type
      obj["related_id"] = post_detail.related_id
      
      rtnPostDetails.push(obj)
    end

    render json: rtnPostDetails
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
      @post_detail.content = post_detail['content']
      @post_detail.quotation_url = post_detail['quotation_url']
      @post_detail.quotation_name = post_detail['quotation_name']
      @post_detail.is_eye_catch = post_detail['is_eye_catch']
      @post_detail.related_type = post_detail['related_type']
      @post_detail.related_id = post_detail['related_id']
      if post_detail['image']
        @post_detail.image = post_detail['image']
      end
      if !@post_detail.save
        isSuccess = false
      end

    end

    if isSuccess
      render json: @post_detail, status: :created
    else
      render json: @post_detail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/post_details/1
  def update
    if @post_detail.update(post_detail_params)
      render json: @post_detail, status: :ok
    else
      render json: @post_detail.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/post_details/1
  def destroy
    id = params[:id]
    PostDetail.accessible_by(current_ability).destroy_all(['post_id = ?', id])
    head :no_content
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def post_detail_params
      params.require(:post_detail).permit(:post_id, :title, :image, :content, :quotation_url, :quotation_name, :is_eye_catch)
    end

end
