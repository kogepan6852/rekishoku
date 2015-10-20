class ShopsController < ApplicationController
  before_action :set_shop, only: [:show, :edit, :update, :destroy]

  # GET /shops
  # GET /shops.json
  def index
    latitudeRange = 0.00000901337 # 緯度計算の値
    longitudeRange = 0.0000109664 # 経度計算の値
    if params[:placeAddress] && params[:shopDistance]
      #現在地を受け取るの緯度経度を求める
      addressPlace = Geocoder.coordinates(params[:placeAddress]);
      # 店舗フィルタをかかる
      @shops = Shop.where('latitude >= ? AND longitude >= ? AND latitude <= ? AND longitude <= ?',addressPlace[0]-params[:shopDistance].to_f*latitudeRange,addressPlace[1]-params[:shopDistance].to_f*longitudeRange,addressPlace[0]+params[:shopDistance].to_f*latitudeRange,addressPlace[1]+params[:shopDistance].to_f*longitudeRange)
    else
      @shops=Shop.all
    end
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
    shop = { "shop" => @shop, "posts" => @shop.posts }
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
      params.require(:shop).permit(:name, :description, :url, :image, :subimage, :image_quotation_url, :image_quotation_name, :post_quotation_url, :post_quotation_name, :address1, :address2, :latitude, :longitude, :menu)
    end
end
