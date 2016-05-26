module ShopInfo
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
