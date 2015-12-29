class ApiShopController < ApplicationController

    # GET /api_shop/shops
    # GET /api_shop/shops.json
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
end
