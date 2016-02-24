class ShopsController < ApplicationController
  load_and_authorize_resource
  before_action :set_shop, only: [:show, :edit, :update, :destroy]
  before_action :set_shopscategories, only: [:new, :edit, :show]
  before_action :set_peopleshops, only: [:new, :edit, :show]

  # GET /shops
  # GET /shops.json
  def index
    @shops = Shop.all.page(params[:page]).per(20).order("created_at DESC")
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
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
    # 住所から緯度経度を求める
    Geocoder.configure(:language  => :ja,  :units => :km )
    addressPlace = Geocoder.coordinates(shop_params[:province]+shop_params[:city]+shop_params[:address1]);
    # 緯度経度を代入する
    @shop = Shop.new(shop_params.merge(latitude: addressPlace[0], longitude: addressPlace[1]))


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
    # 住所から緯度経度を求める
    Geocoder.configure(:language  => :ja,  :units => :km )
    addressPlace = Geocoder.coordinates(shop_params[:province]+shop_params[:city]+shop_params[:address1]);
    # 緯度経度を代入する
    @shop.update(shop_params.merge(latitude: addressPlace[0], longitude: addressPlace[1]))
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

    def set_shopscategories
      @shops_categories = ShopCategory.all
    end

    def set_peopleshops
      @people = Person.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shop_params
      params.require(:shop).permit(:name, :description, :url, :image, :subimage, :image_quotation_url, :image_quotation_name, :post_quotation_url, :post_quotation_name, :province, :city, :address1, :address2, :latitude, :longitude, :menu, :province, :city, :id, :category_ids => [], :person_ids => [])
    end

end
