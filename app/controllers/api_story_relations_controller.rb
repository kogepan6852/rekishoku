class ApiStoryRelationsController < ApplicationController

  include ShopInfo
  include RelatedInfo

  # GET /api/story_relations/1
  def index
    @story_relations = StoryRelation.where(story_id: params[:id]).order(:order, id: :asc)

    # それぞれの詳細対応
    rtnstoryDetails = Array.new()
    @story_relations.each do |story_relation|
      obj = {}

      if story_relation[:related_type] == "Shop"

        # 対応するShopの情報を取得する
        shop = Shop.joins("LEFT OUTER JOIN period_translations ON shops.period_id = period_translations.period_id")
        .select('shops.*, period_translations.name as period_name').find(story_relation[:related_id])

        obj = get_shop_json(shop)
        # detail["shop"] = obj
      elsif story_relation[:related_type] == "Story"

        # 対応するstoryの情報を取得する
        story = Story.joins(:category).select('stories.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').find(story_detail[:related_id])

        obj = get_story_json(story)
        # detail["story"] = obj
      elsif story_relation[:related_type] == "ExternalLink"

        # 対応するExternalLinkの情報を取得する
        obj = get_external_link_json(story_relation.related)

      end

      obj["story_detail_id"] = story_relation.story_detail_id

      rtnstoryDetails.push(obj)
    end

    render json: rtnstoryDetails
  end

  # story /api/story_details
  # def show
  #   isSuccess = true
  #   story_detail = params[:story_details]
  #   params[:story_details].each_with_index do |story_detail, i|
  #     if story_detail['id']
  #       # 更新処理
  #       @story_detail = StoryDetail.find(story_detail['id'])
  #     else
  #       # 新規作成処理
  #       @story_detail = StoryDetail.new
  #     end
  #
  #     @story_detail.story_id = story_detail['story_id']
  #     @story_detail.title = story_detail['title']
  #     @story_detail.content = story_detail['content']
  #     @story_detail.quotation_url = story_detail['quotation_url']
  #     @story_detail.quotation_name = story_detail['quotation_name']
  #     @story_detail.is_eye_catch = story_detail['is_eye_catch']
  #     @story_detail.related_type = story_detail['related_type']
  #     @story_detail.related_id = story_detail['related_id']
  #     if story_detail['image']
  #       @story_detail.image = story_detail['image']
  #     end
  #     if !@story_detail.save
  #       isSuccess = false
  #     end
  #
  #   end
  #
  #   if isSuccess
  #     render json: @story_detail, status: :created
  #   else
  #     render json: @story_detail.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /api/story_details/1
  # def update
  #   if @story_detail.update(story_detail_params)
  #     render json: @story_detail, status: :ok
  #   else
  #     render json: @story_detail.errors, status: :unprocessable_entity
  #   end
  # end
  #
  # # DELETE /api/story_details/1
  # def destroy
  #   id = params[:id]
  #   StoryDetail.accessible_by(current_ability).destroy_all(['story_id = ?', id])
  #   head :no_content
  # end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def story_detail_params
      params.require(:story_relation).permit(:story_id, :story_detail_id, :related_type, :related_id, :order)
    end

end
