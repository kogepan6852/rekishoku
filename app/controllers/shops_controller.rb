class ShopsController < ApplicationController
  before_action :set_shop, only: [:show, :edit, :update, :destroy]

  # GET /shops
  # GET /shops.json
  def index
    filterFlag = 0
    latitudeRange = 0.00000901337 # 緯度計算の値
    longitudeRange = 0.0000109664 # 経度計算の値

    @shops = Shop.order(created_at: :desc)
    if params[:placeAddress] && params[:shopDistance]
      #現在地を受け取るの緯度経度を求める
      Geocoder.configure(:language => :ja)
      addressPlace = Geocoder.coordinates(params[:placeAddress]);
      # 店舗フィルタをかける
      @shops = @shops.where('latitude >= ? AND longitude >= ? AND latitude <= ? AND longitude <= ?',addressPlace[0]-params[:shopDistance].to_f*latitudeRange,addressPlace[1]-params[:shopDistance].to_f*longitudeRange,addressPlace[0]+params[:shopDistance].to_f*latitudeRange,addressPlace[1]+params[:shopDistance].to_f*longitudeRange)

      # jsonの場合、戻り値に現在地の経度緯度を追加
      shops = { "shops" => @shops, "current" => { "latitude" => addressPlace[0], "longitude" => addressPlace[1], "address" => params[:placeAddress] }}
    elsif params[:longitude] && params[:latitude] && params[:shopDistance]
      # 住所情報の取得
      input = params[:latitude] + ',' + params[:longitude]
      Geocoder.configure(:language => :ja)
      address = Geocoder.address(input);
      addressArray = address.split(" ")
      # 店舗情報の取得
      minLatitude = params[:latitude].to_f - params[:shopDistance].to_f*latitudeRange
      minLongitude = params[:longitude].to_f - params[:shopDistance].to_f*longitudeRange
      maxLatitude = params[:latitude].to_f + params[:shopDistance].to_f*latitudeRange
      maxLongitude = params[:longitude].to_f + params[:shopDistance].to_f*longitudeRange
      @shops = Shop.where('latitude >= ? AND longitude >= ? AND latitude <= ? AND longitude <= ?', minLatitude, minLongitude, maxLatitude, maxLongitude)

      # jsonの場合、戻り値に現在地の経度緯度を追加
      shops = { "shops" => @shops, "current" => { "latitude" => params[:latitude], "longitude" => params[:longitude], "address" => addressArray[2] }}
    else
      if params[:name] || params[:category] || params[:placeAddress]
        # 住所（部分一致）と店舗名機能（部分一致含む）とカテゴリ　
        if params[:name]
          @shops = @shops.where('name LIKE ?',params[:name])
        end
        if params[:category]
          @shops = @shops.joins(:categories).where('categories_shops.category_id = ?', params[:category].to_i)
        end
        if params[:placeAddress]
          @shops = @shops.where('address1 LIKE ?', params[:placeAddress])
        end
      end
      # shopにカテゴリーを紐付ける
      newShops = Array.new()
      @shops.page(params[:page]).per(params[:per]).each do |shop|
        obj = { "shop" => shop, "categories" => shop.categories }
        newShops.push(obj);
      end
      shops = newShops
    end

    respond_to do |format|
      format.html {}
      format.json { render json: shops }
    end

  end

  # GET /shops/1
  # GET /shops/1.json
  def show
    shop = { "shop" => @shop, "categories" => @shop.categories, "posts" => @shop.posts.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug') }
    respond_to do |format|
      format.html { render @shops }
      format.json { render json: shop }
    end
  end

  # GET /shops/new
  def new
    @shop = Shop.new
  end

  # GET /shops/1/edit
  def edit
  end

  # POST /shops
  # POST /shops.json
  def create
    @shop = Shop.new(shop_params)

    respond_to do |format|
      if @shop.save
        format.html { redirect_to @shop, notice: 'Shop was successfully created.' }
        format.json { render :show, status: :created, location: @shop }
      else
        format.html { render :new }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shops/1
  # PATCH/PUT /shops/1.json
  def update
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to @shop, notice: 'Shop was successfully updated.' }
        format.json { render :show, status: :ok, location: @shop }
      else
        format.html { render :edit }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    @shop.destroy
    respond_to do |format|
      format.html { redirect_to shops_url, notice: 'Shop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shop_params
      params.require(:shop).permit(:name, :description, :url, :image, :subimage, :image_quotation_url, :image_quotation_name, :post_quotation_url, :post_quotation_name, :province, :city, :address1, :address2, :latitude, :longitude, :menu,:province ,:city)
    end
end
