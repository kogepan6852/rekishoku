module RelatedInfo
  def get_post(post)
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

    return postObj
  end

  # 対象の人物から紐づく時代を取得する
  def get_periods(people)
    periods = Array.new()
    people.each do |person|
      person.periods.each do |period|
        periods.push(period);
      end
    end
    return periods.sort{ |a, b| a[:id] <=> b[:id] }
  end

  # 対象の情報から紐づく人物を取得する
  def get_people(article)
    people = Array.new()
    article.people.order(rating: :desc).each do |person|
      if person[:rating] != 0.0
         personApi = {
           "id" => person.id,
           "name" => person.name
         }
         people.push(personApi)
      end
    end
    return people
  end


  # 対象の情報から紐づくカテゴリを整理する
  def get_categories(check_categories)

    categories = Array.new()
    check_categories.each do |category|
      categoryApi = {
        "id" => category.id,
        "name" => category.name
      }
      categories.push(categoryApi)
    end
    return categories

  end



  def get_shop_json(shop)
    # shopsに紐付いてる人物を取得する
    people = get_people(shop)
    # 歴食度の設定
    rating = cal_rating(shop)
    # 価格帯の取得
    price = get_price(shop)
    # カテゴリ設定
    categories = get_categories(shop.categories)

    # 返却用のオブジェクトを作成する
    obj = { "id" => shop.id,
            "name" => shop.name,
            "menu" => shop.menu,
            "subimage" => shop.subimage,
            "province" => shop.province,
            "city" => shop.city,
            "period_id" => shop.period_id,
            "period_name" => shop.period_name,
            "daytime" => price[0],
            "nighttime" => price[1],
            "categories" => categories,
            "people" => people.uniq,
            "rating" => rating
          }
    return obj
  end

  def get_post_json(post)
    # アイキャッチ画像の設定
    postObj = get_post(post)
    # postsに紐付いてる人物を取得する
    people = get_people(post)
    # postsに紐付けしている時代を取得をする
    periods = get_periods(post.people)

    # 返却用のオブジェクトを作成する
    obj = { "post" => postObj,
            "people" => people.uniq,
            "periods" => periods.uniq
          }
    return obj
  end

  def get_feature_json(feature)
    periods = Array.new()
    people = Array.new()

    # featureに紐付いてる人物を取得する
    people = get_people(feature)
    # featureに紐付けしている時代を取得をする
    periods = get_periods(feature.people)

    # 返却用のオブジェクトを作成する
    obj = {
            "feature" => feature,
            "people" => people.uniq,
            "periods" => periods.uniq
          }
    return obj
  end

  def get_external_link_json(external_link)
    # external_linkに紐付いてる人物を取得する
    people = get_people(external_link)
    # external_linkに紐付けしている時代を取得をする
    periods = get_periods(external_link.people)
    # 返却用のオブジェクトを作成する
    obj = { "external_link" => external_link,
            "people" => people.uniq,
            "periods" => periods.uniq
          }
    return obj
  end

  def get_favorite_json(favorite)
    obj = {
            "favorite" => favorite
          }
    return obj
  end

  private
    # 対象のお店から紐づく人物を取得する
    def get_people_feature(articles)
      people = Array.new()
      articles.each do |article|
        article.people.each do |person|
            people.push(person)
        end
      end
      return people
    end
end
