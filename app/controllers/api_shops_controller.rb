class ApiShopsController < ApplicationController

  include ShopInfo
  include RelatedInfo

  # GET /api/shops
  # 一覧表示
  def index
    @shops = Shop.order(created_at: :desc, id: :desc).joins("LEFT OUTER JOIN periods ON shops.period_id = periods.id").select('shops.*, periods.name as period_name')

    # フリーワードで検索
    if params[:keywords]
      keywords = params[:keywords]
      for kw in keywords.gsub("　", " ").split(" ")
        # 名前&詳細&メニュー&住所&人物で検索(outer_join仕様)
        @shops = @shops
          .eager_load(:people)
          .where('shops.name LIKE ? or shops.description LIKE ? or shops.menu LIKE ? or CONCAT(shops.province, shops.city, shops.address1, shops.address2) LIKE ? or people.name LIKE ?',"%#{kw}%", "%#{kw}%", "%#{kw}%", "%#{kw}%", "%#{kw}%").uniq
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
    @shop = Shop.joins("LEFT OUTER JOIN periods ON shops.period_id = periods.id").select('shops.*, periods.name as period_name').find(params[:id])

    # shopに紐付いてる人物を取得する
    people = get_people(@shop)

    # 歴食度の設定
    rating = cal_rating(@shop)
    # 価格帯の取得
    price = get_price(@shop)

    # 関連する投稿の取得
    posts = @shop.posts.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').where("status = ? and published_at <= ?", 1, Time.zone.now).order(published_at: :desc)
    newPosts = Array.new()

    posts.each do |post|
      newPosts.push(get_post_json(post));
    end

    # 返却用のオブジェクトを作成する
    rtnObj = { "shop" => @shop,
             "categories" => @shop.categories,
             "posts" => newPosts,
             "people" =>  people.uniq,
             "rating" => rating,
             "price" => price
           }
    render json: rtnObj
  end

  # GET /api/map
  # Map検索用一覧表示
  def map
    latitudeRange = 0.00000901337 # 緯度計算の値
    longitudeRange = 0.0000109664 # 経度計算の値

    @shops = Shop.order(created_at: :desc)
    # 店舗情報の取得
    minLatitude = params[:latitude].to_f - params[:shopDistance].to_f*latitudeRange
    minLongitude = params[:longitude].to_f - params[:shopDistance].to_f*longitudeRange
    maxLatitude = params[:latitude].to_f + params[:shopDistance].to_f*latitudeRange
    maxLongitude = params[:longitude].to_f + params[:shopDistance].to_f*longitudeRange
    @shops = Shop.where('latitude >= ? AND longitude >= ? AND latitude <= ? AND longitude <= ?', minLatitude, minLongitude, maxLatitude, maxLongitude)

    # フリーワードで検索
    if params[:keywords]
      keywords = params[:keywords]
      for kw in keywords.gsub("　", " ").split(" ")
        # 名前&詳細&メニュー&住所&人物で検索(outer_join仕様)
        @shops = @shops
          .eager_load(:people)
          .where('shops.name LIKE ? or shops.description LIKE ? or shops.menu LIKE ? or CONCAT(shops.province, shops.city, shops.address1, shops.address2) LIKE ? or people.name LIKE ?',"%#{kw}%", "%#{kw}%", "%#{kw}%", "%#{kw}%", "%#{kw}%").uniq
      end
    end

    # カテゴリーで検索
    if params[:category]
      @shops = @shops.joins(:categories).where('categories_shops.category_id = ?', params[:category].to_i)
    end

    if params[:period]
      # 時代で検索
      person = Person.select('distinct people.id').joins(:periods)
        .where('periods.id' => params[:period])
      @shops = @shops.joins(:people).where('people.id' => person).uniq
    end

    if params[:person]
      # 人物で検索
      @shops = @shops.joins(:people).where('people.id' => params[:person]).uniq
    end

    # 都道府県検索
    if params[:province]
      @shops = @shops.where(province: params[:province])
    end

    shops = { "shops" => @shops }
    render json: shops
  end

  # GET /api/shop-list.json
  # post-list用一覧表示
  def list
    @shops = Shop.all
    shops = Array.new()
    @shops.each do |shop|
      # 対象のpostが紐付いているかチェック
      hasPost = false
      shop.posts.each do |post|
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
