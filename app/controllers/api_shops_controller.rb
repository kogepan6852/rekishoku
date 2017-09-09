class ApiShopsController < ApplicationController

  include ShopInfo
  include RelatedInfo

  # GET /api/shops
  # 一覧表示
  def index
    @shops = Shop.order(created_at: :desc, id: :desc).joins("LEFT OUTER JOIN period_translations ON shops.period_id = period_translations.period_id").select('shops.*, period_translations.name as period_name')

    # フリーワードで検索
    if params[:keywords]
      keywords = params[:keywords]
      for kw in keywords.gsub("　", " ").split(" ")
        # 名前&詳細&メニュー&住所&人物で検索(outer_join仕様)
        @shops = @shops
          .eager_load(:person_translations, :shop_translations)
          .where('shop_translations.name LIKE ? or shop_translations.description LIKE ? or shop_translations.menu LIKE ? or CONCAT(shop_translations.province, shop_translations.city, shop_translations.address1, shop_translations.address2) LIKE ? or person_translations.name LIKE ?',"%#{kw}%", "%#{kw}%", "%#{kw}%", "%#{kw}%", "%#{kw}%").uniq
      end
    end
    # カテゴリーで検索
    if params[:category]
      @shops = @shops.joins(:categories).where('categories_shops.category_id = ?', params[:category].to_i)
    end

    # 時代で検索
    if params[:period]
      person = Person.select('distinct people.id').joins(:periods)
        .where('periods.id' => params[:period])
      @shops = @shops.joins(:people).where('people.id' => person).uniq
    end

    # 人物で検索
    if params[:person]
      @shops = @shops.joins(:people).where('people.id' => params[:person]).uniq
    end

    # 都道府県検索
    if params[:province]
      @shops = @shops.where(province: params[:province])
    end

    if params[:latitude] && params[:longitude]
      minLatitude = params[:latitude].to_f - params[:shopDistance].to_f*latitudeRange
      minLongitude = params[:longitude].to_f - params[:shopDistance].to_f*longitudeRange
      maxLatitude = params[:latitude].to_f + params[:shopDistance].to_f*latitudeRange
      maxLongitude = params[:longitude].to_f + params[:shopDistance].to_f*longitudeRange
      @shops = Shop.where('latitude >= ? AND longitude >= ? AND latitude <= ? AND longitude <= ?', minLatitude, minLongitude, maxLatitude, maxLongitude)
    end

    # shopにカテゴリーを紐付ける
    if params[:page] && params[:per]
      newShops = Array.new()
      @shops.page(params[:page]).per(params[:per]).each do |shop|
        newShops.push(get_shop_json(shop))
      end
      shops = newShops
    else
      shops = @shops
    end
    render json: shops
  end

  # GET /api/shops/1
  # 詳細データ表示
  def show
    @shop = Shop.joins("LEFT OUTER JOIN shop_translations ON shops.id = shop_translations.shop_id").select('shops.*, shop_translations.name as name').find(params[:id])

    # shopに紐付いてる人物を取得する
    people = get_people(@shop)

    # 歴食度の設定
    rating = cal_rating(@shop)
    # 価格帯の取得
    price = get_price(@shop)
    # カテゴリ設定
    categories = get_categories(@shop.categories)

    # 返却用のオブジェクトを作成する
    rtnObj = { "shop" => @shop,
             "categories" => categories,
             "people" =>  people.uniq,
             "rating" => rating,
             "price" => price
           }
    render json: rtnObj
  end


  # GET /api/shop-list.json
  # post-list用一覧表示
  def list
    @shops = Shop.joins("LEFT OUTER JOIN shop_translations ON shops.id = shop_translations.shop_id").select('shops.*, shop_translations.name as name')
    shops = Array.new()
    @shops.each do |shop|
      # 対象のpostが紐付いているかチェック
      hasPost = false
      shop.stories.each do |post|
        if post.id == params[:post_id].to_i
          hasPost = true
        end
      end
      obj = { "id" => shop.id, "name" => shop.name, "hasPost" => hasPost}
      shops.push(obj);
    end
    render json: shops
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def shop_params
      params.require(:shop).permit(:name, :description, :url, :image, :subimage, :image_quotation_url, :image_quotation_name, :post_quotation_url, :post_quotation_name, :province, :city, :address1, :address2, :latitude, :period_id, :longitude, :menu, :province, :city, :id, :category_ids => [], :person_ids => [])
    end

end
