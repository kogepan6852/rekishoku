class ApiStoryDetailsController < ApplicationController
  authorize_resource :class => false

  include ShopInfo
  include RelatedInfo

  # GET /api/story_details/1
  def index
    story_details = StoryDetail.where(story_id: params[:id]).order(:order, id: :asc)

    # それぞれの詳細対応
    rtnstoryDetails = Array.new()
    story_details.each do |story_detail|
      obj = {}

      if story_detail[:related_type] == "Shop"

        # 対応するShopの情報を取得する
        shop = Shop.joins("LEFT OUTER JOIN periods ON shops.period_id = periods.id").select('shops.*, periods.name as period_name').find(story_detail[:related_id])

        obj = get_shop_json(shop)
        # detail["shop"] = obj
      elsif story_detail[:related_type] == "Story"

        # 対応するstoryの情報を取得する
        story = Story.joins(:category).select('stories.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').find(story_detail[:related_id])

        obj = get_story_json(story)
        # detail["story"] = obj
      elsif story_detail[:related_type] == "ExternalLink"

        # 対応するExternalLinkの情報を取得する
        obj = get_external_link_json(story_detail.related)
        # detail["external_link"] = obj

      end

      obj["id"] = story_detail.id
      obj["title"] = story_detail.title
      obj["content"] = story_detail.content
      obj["image"] = story_detail.image
      obj["quotation_url"] = story_detail.quotation_url
      obj["quotation_name"] = story_detail.quotation_name
      obj["is_eye_catch"] = story_detail.is_eye_catch
      obj["related_type"] = story_detail.related_type
      obj["related_id"] = story_detail.related_id

      rtnstoryDetails.push(obj)
    end

    render json: rtnstoryDetails
  end

  # story /api/story_details
  def create
    isSuccess = true
    story_detail = params[:story_details]
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
      @story_detail.content = story_detail['content']
      @story_detail.quotation_url = story_detail['quotation_url']
      @story_detail.quotation_name = story_detail['quotation_name']
      @story_detail.is_eye_catch = story_detail['is_eye_catch']
      @story_detail.related_type = story_detail['related_type']
      @story_detail.related_id = story_detail['related_id']
      if story_detail['image']
        @story_detail.image = story_detail['image']
      end
      if !@story_detail.save
        isSuccess = false
      end

    end

    if isSuccess
      render json: @story_detail, status: :created
    else
      render json: @story_detail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/story_details/1
  def update
    if @story_detail.update(story_detail_params)
      render json: @story_detail, status: :ok
    else
      render json: @story_detail.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/story_details/1
  def destroy
    id = params[:id]
    StoryDetail.accessible_by(current_ability).destroy_all(['story_id = ?', id])
    head :no_content
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def story_detail_params
      params.require(:story_detail).permit(:story_id, :title, :image, :content, :quotation_url, :quotation_name, :is_eye_catch)
    end

end
