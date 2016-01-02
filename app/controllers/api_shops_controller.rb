class ApiShopsController < ApplicationController

  # GET /api/shops
  def index
    @shops = Shop.order(created_at: :desc)
    # 検索条件の設定
    if params[:name]
      @shops = @shops.where('name LIKE ?',params[:name])
    end
    if params[:category]
      @shops = @shops.joins(:categories).where('categories_shops.category_id = ?', params[:category].to_i)
    end
    if params[:address]
      @shops = @shops.where('address1 LIKE ?', params[:address])
    end

    # shopにカテゴリーを紐付ける
    if params[:page] && params[:per]
      newShops = Array.new()
      @shops.page(params[:page]).per(params[:per]).each do |shop|
        obj = { "shop" => shop,
                "categories" => shop.categories ,
                "people" => shop.people }
        newShops.push(obj);
      end
      shops = newShops
    else
      shops = @shops
    end

    render json: shops
  end

  # GET /api/shops/1
  def show
    @shop = Shop.find(params[:id])
    shop = { "shop" => @shop,
             "categories" => @shop.categories,
             "posts" => @shop.posts.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug'),
             "people" => @shop.people }
    render json: shop
  end

  # GET /api/map
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

    shops = { "shops" => @shops }
    render json: shops
  end

  # GET /api/shop-list.json
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
      params.require(:shop).permit(:name, :description, :url, :image, :subimage, :image_quotation_url, :image_quotation_name, :post_quotation_url, :post_quotation_name, :province, :city, :address1, :address2, :latitude, :longitude, :menu, :province, :city, :id, :category_ids => [], :person_ids => [])
    end
end
