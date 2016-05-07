class ApiShopsController < ApplicationController

  # GET /api/shops
  # 一覧表示
  def index
    @shops = Shop.order(created_at: :desc)
    # 検索条件の設定
    if params[:keywords]
      keywords = params[:keywords]
      for kw in keywords.split(" ")
        # 名前&詳細&メニュー&住所&人物で検索(outer_join仕様)
        @shops = @shops
          .eager_load(:people)
          .where('shops.name LIKE ? or shops.description LIKE ? or shops.menu LIKE ? or CONCAT(shops.province, shops.city, shops.address1, shops.address2) LIKE ? or people.name LIKE ?',"%#{kw}%", "%#{kw}%", "%#{kw}%", "%#{kw}%", "%#{kw}%").uniq
      end
    end
    if params[:category]
      # カテゴリーで検索
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

    if params[:province]
      # 都道府県検索
      @shops = @shops.where(province: params[:province])
    end

    # shopにカテゴリーを紐付ける
    if params[:page] && params[:per]
      newShops = Array.new()
      @shops.page(params[:page]).per(params[:per]).each do |shop|
        # 人に紐付く時代を全て抽出する
        periods = Array.new()
        shop.people.each do |person|
          person.periods.each do |period|
            periods.push(period);
          end
        end

        # 歴食度の設定
        rating = cal_rating(shop)
        # 価格帯の取得
        price = get_price(shop)

        # 返却用のオブジェクトを作成する
        obj = { "shop" => shop,
                "categories" => shop.categories,
                "people" => shop.people,
                "periods" => periods.uniq,
                "rating" => rating,
                "price" => price
              }
        newShops.push(obj);
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
    @shop = Shop.find(params[:id])

    # 人に紐付く時代を全て抽出する
    periods = Array.new()
    @shop.people.each do |person|
      person.periods.each do |period|
        periods.push(period);
      end
    end

    # 歴食度の設定
    rating = cal_rating(@shop)
    # 価格帯の取得
    price = get_price(@shop)

    # 関連する投稿の取得
    posts = @shop.posts.joins(:category).select('posts.*, categories.id as category_id, categories.name as category_name, categories.slug as category_slug').where("status = ? and published_at <= ?", 1, Date.today).order(published_at: :desc)
    newPosts = Array.new()

    posts.each do |post|
      # アイキャッチ画像の設定
      postObj = { "id" => post.id,
              "title" => post.title,
              "content" => post.content,
              "image" => post.image,
              "published_at" => post.published_at,
              "category_id" => post.category_id,
              "category_name" => post.category_name,
              "category_slug" => post.category_slug }
      post.post_details.each do |post_detail|
        if post_detail.is_eye_catch
          postObj["image"] = post_detail.image
        end
      end

      # 人に紐付く時代を全て抽出する
      periods = Array.new()
      post.people.each do |person|
        person.periods.each do |period|
          periods.push(period);
        end
      end
      # 返却用のオブジェクトを作成する
      obj = { "post" => postObj,
              "people" => post.people,
              "periods" => periods.uniq
            }

      newPosts.push(obj);
    end

    # 返却用のオブジェクトを作成する
    rtnObj = { "shop" => @shop,
             "categories" => @shop.categories,
             "posts" => newPosts,
             "people" => @shop.people,
             "periods" => periods.uniq,
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
      params.require(:shop).permit(:name, :description, :url, :image, :subimage, :image_quotation_url, :image_quotation_name, :post_quotation_url, :post_quotation_name, :province, :city, :address1, :address2, :latitude, :longitude, :menu, :province, :city, :id, :category_ids => [], :person_ids => [])
    end

    # 価格帯の取得
    def get_price(shop)
      price = {}
      if shop.daytime_price && shop.nighttime_price
        price = {
          "daytime" => shop.daytime_price.min.to_s(:delimited) + ' - ' + shop.daytime_price.max.to_s(:delimited),
          "nighttime" => shop.nighttime_price.min.to_s(:delimited) + ' - ' + shop.nighttime_price.max.to_s(:delimited)
        }
      end
      return price
    end

    # 歴食度の設定
    def cal_rating(shop)
      history = shop.history_level >= 0 ? shop.history_level : nil
      building = shop.building_level >= 0 ? shop.building_level : nil
      menu = shop.menu_level >= 0 ? shop.menu_level : nil
      person = shop.person_level >= 0 ? shop.person_level : nil
      episode = shop.episode_level >= 0 ? shop.episode_level : nil

      validLevel = history == nil ? 0 : 1
      validLevel += building == nil ? 0 : 1
      validLevel += menu == nil ? 0 : 1
      validLevel += person == nil ? 0 : 1
      validLevel += episode == nil ? 0 : 1

      average_level = ((history.to_i + building.to_i + menu.to_i + person.to_i + episode.to_i) / validLevel.to_f).round(1)

      rating = {
        "average" => average_level,
        "detail" => {
          "history" => history,
          "building" => building,
          "menu" => menu,
          "person" => person,
          "episode" => episode
        },
      }
      return rating
    end

end
