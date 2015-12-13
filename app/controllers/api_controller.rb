class ApiController < ApplicationController
    before_action :set_periods, only: [:periods]

    # GET /api/people
    # GET /api/people.json
    def people
      @people = Person.all
      respond_to do |format|
        format.html {}
        format.json { render json: @people }
      end
    end

    # GET /api/periods
    # GET /api/periods_api.json
    def periods
    end

    # GET /api/shops
    # GET /api/shops.json
    def shops
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
        if params[:page] && params[:per]
          @shops.page(params[:page]).per(params[:per]).each do |shop|
            obj = { "shop" => shop, "categories" => shop.categories , "people" => shop.people}
            newShops.push(obj);
          end
          shops = newShops
        else
          shops = @shops.accessible_by(current_ability)
        end
      end

      if params[:id]
        shops = Shop.find(params[:id])
        shops = { "shop" => shops, "categories" => shops.categories, "posts" => shops.posts.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug'), "people" => shops.people }
      end


      respond_to do |format|
        format.html {}
        format.json { render json: shops }
      end

    end

    # GET /api/people_posts/1
    # GET /api/people_posts/1.json
    def people_post
      @people_posts = PeoplePost.new
      render json: @people_posts
    end

    # GET /api/people_shops/1
    # GET /api/people_shops.json
    def people_shops
      @person = Person.find(params[:id])
    end

    def post_details
      @post_details = PostDetail.accessible_by(current_ability).where(post_id: params[:id]).order(id: :asc)
      render json: @post_details
    end

    def post_show
      @post = Post.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').find(params[:id])
      shops = Array.new()
      @post.shops.each do |shop|
        obj = { "shop" => shop, "categories" => shop.categories }
        shops.push(obj);
      end
      post = { "post" => @post, "shops" => shops }
      render json: post
    end

    def posts_shops
      @posts_shop = PostsShop.find(params[:id])
    end

    def category
      @category = Category.find(params[:id])
    end

    private

      def set_periods
        @periods = Period.all
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def shop_params
        params.require(:shop).permit(:name, :description, :url, :image, :subimage, :image_quotation_url, :image_quotation_name, :post_quotation_url, :post_quotation_name, :province, :city, :address1, :address2, :latitude, :longitude, :menu, :province, :city, :id, :category_ids => [], :person_ids => [])
      end

      def posts_shop_params
        params.require(:posts_shop).permit(:post_id, :shop_id)
      end

      def post_params
        params.require(:post).permit(:title, :content, :image, :favorite_count, :status, :user_id, :quotation_url, :quotation_name, :category_id, :memo)
      end

      def period_params
        params.require(:period).permit(:name)
      end

      def people_shop_params
        params.require(:people_shop).permit(:person_id, :shop_id)
      end

      def people_post_params
        params.require(:people_post).permit(:person_id, :post_id)
      end

      def person_params
        params.require(:person).permit(:name, :furigana, :id, :period_ids => [], :category_ids => [])
      end

      def category_params
        params.require(:category).permit(:name, :slug, :type)
      end


end
