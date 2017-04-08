module ShopInfo
  # 価格帯の取得
  def get_price(shop)
    price = Array.new()
    daytime = nil
    nighttime = nil

    if shop.daytime_price
      daytime = {
        "min" => shop.daytime_price.min,
        "max" => shop.daytime_price.max
      }
    end

    if shop.nighttime_price
      nighttime = {
        "min" => shop.nighttime_price.min,
        "max" => shop.nighttime_price.max
      }
    end

    price = {
      "daytime" => daytime,
      "nighttime" => nighttime
    }

    return price
  end

  # 歴食度の設定
  def cal_rating(shop)
    history = shop.history_level
    building = shop.building_level
    menu = shop.menu_level
    person = shop.person_level
    episode = shop.episode_level

    validLevel = history == nil ? 0 : 1
    validLevel += building == nil ? 0 : 1
    validLevel += menu == nil ? 0 : 1
    validLevel += person == nil ? 0 : 1
    validLevel += episode == nil ? 0 : 1

    average_level = ((history.to_i + building.to_i + menu.to_i + person.to_i + episode.to_i) / validLevel.to_f).round(1)

    rating = {
      "average" => average_level,
      "history" => history,
      "building" => building,
      "menu" => menu,
      "person" => person,
      "episode" => episode
    }
    return rating
  end

end
