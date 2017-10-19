module RelatedInfo
  def get_story(story)
    # アイキャッチ画像の設定
    storyObj = { "id" => story.id,
            "title" => story.title,
            "content" => story.content,
            "image" => story.image,
            "published_at" => story.published_at,
            "category_id" => story.category_id,
            "category_name" => story.category_name,
            "category_slug" => story.category_slug }
    story.story_details.each do |story_detail|
      if story_detail.is_eye_catch
        postObj["image"] = story_detail.image
      end
    end

    return storyObj
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
    obj = shop.attributes
    obj["image"] = shop.image
    obj["subimage"] = shop.subimage
    obj["price"] = price
    obj["categories"] = categories
    obj["people"] = people.uniq
    obj["rating"] = rating
    return obj
  end

  def get_story_json(story)
    # アイキャッチ画像の設定
    storyObj = story.attributes
    storyObj["image"] = story.image
    storyObj["user_name"] =  story.user.username
    # postsに紐付いてる人物を取得する
    storyObj["people"] = get_people(story).uniq
    # postsに紐付けしている時代を取得をする
    storyObj["periods"] = get_periods(story.people).uniq

    # 返却用のオブジェクトを作成する
    return storyObj
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
    obj = external_link.attributes
    obj["image"] = external_link.image
    # postsに紐付いてる人物を取得する
    obj["people"] = get_people(external_link).uniq
    # postsに紐付けしている時代を取得をする
    obj["periods"] = get_periods(external_link.people).uniq
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
