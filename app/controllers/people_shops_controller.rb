class PeopleShopsController < ApplicationController
  load_and_authorize_resource
  before_action :set_people_shop, only: [:show, :edit, :update, :destroy]

  # GET /people_shops
  # GET /people_shops.json
  def index
    @people_shops = PeopleShop.all
  end

  # GET /people_shops/1
  # GET /people_shops/1.json
  def show
  end

  # GET /people_shops/new
  def new
    @people_shop = PeopleShop.new
  end

  # GET /people_shops/1/edit
  def edit
  end

  # POST /people_shops
  # POST /people_shops.json
  def create
    @people_shop = PeopleShop.new(people_shop_params)

    respond_to do |format|
      if @people_shop.save
        format.html { redirect_to @people_shop, notice: 'People shop was successfully created.' }
        format.json { render :show, status: :created, location: @people_shop }
      else
        format.html { render :new }
        format.json { render json: @people_shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people_shops/1
  # PATCH/PUT /people_shops/1.json
  def update
    respond_to do |format|
      if @people_shop.update(people_shop_params)
        format.html { redirect_to @people_shop, notice: 'People shop was successfully updated.' }
        format.json { render :show, status: :ok, location: @people_shop }
      else
        format.html { render :edit }
        format.json { render json: @people_shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people_shops/1
  # DELETE /people_shops/1.json
  def destroy
    @people_shop.destroy
    respond_to do |format|
      format.html { redirect_to people_shops_url, notice: 'People shop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_people_shop
      @people_shop = PeopleShop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def people_shop_params
      params.require(:people_shop).permit(:person_id, :shop_id)
    end
end
