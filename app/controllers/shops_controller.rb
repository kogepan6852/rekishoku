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
    #歴食度_合計
    total = shop_params[:history_level].to_i + shop_params[:building_level].to_i + shop_params[:menu_level].to_i + shop_params[:person_level].to_i + shop_params[:episode_level].to_i
    # 緯度経度と歴食度を代入する
    @shop = Shop.new(shop_params.merge(latitude: addressPlace[0], longitude: addressPlace[1], total_level: total))
    @shop.save
    redirect_to "/admin/shop"
  end

  # PATCH/PUT /shops/1
  # PATCH/PUT /shops/1.json
  def update
    # 住所から緯度経度を求める
    Geocoder.configure(:language  => :ja,  :units => :km )
    addressPlace = Geocoder.coordinates(shop_params[:province]+shop_params[:city]+shop_params[:address1]);
    #歴食度_合計
    total = shop_params[:history_level].to_i + shop_params[:building_level].to_i + shop_params[:menu_level].to_i + shop_params[:person_level].to_i + shop_params[:episode_level].to_i
    # 緯度経度と歴食度を代入する
    @shop.update(shop_params.merge(latitude: addressPlace[0], longitude: addressPlace[1], total_level: total))
    #redirect_to :back
    redirect_to "/admin/shop"
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
      params.require(:shop).permit(:name, :description, :url, :image, :subimage, :image_quotation_url, :image_quotation_name, :post_quotation_url, :post_quotation_name, :province, :city, :address1, :address2, :latitude, :longitude, :menu, :province, :city, :id, :history_level, :building_level, :phone_no, :daytime_price_id, :nighttime_price_id, :shop_hours, :is_closed_sun, :is_closed_mon, :is_closed_tue, :is_closed_wed, :is_closed_thu, :is_closed_fri, :is_closed_sat, :is_closed_hol, :is_approved, :closed_pattern, :total_level, :menu_level, :episode_level, :person_level, :category_ids => [], :person_ids => [])
    end

end
