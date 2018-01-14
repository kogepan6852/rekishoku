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
        story = Story.joins(:category).joins("LEFT OUTER JOIN category_translations ON stories.category_id = category_translations.category_id")
        .select('stories.*, categories.id as category_id, category_translations.name as category_name, categories.slug as category_slug').find(story_relation[:related_id])

        obj = get_story_json(story)
        # detail["story"] = obj
      elsif story_relation[:related_type] == "ExternalLink"

        # 対応するExternalLinkの情報を取得する
        obj = get_external_link_json(story_relation.related)

      end

      obj["story_detail_id"] = story_relation.story_detail_id
      obj["order"] = story_relation.order

      rtnstoryDetails.push(obj)
    end

    render json: rtnstoryDetails
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def story_detail_params
      params.require(:story_relation).permit(:story_id, :story_detail_id, :related_type, :related_id, :order)
    end

end
