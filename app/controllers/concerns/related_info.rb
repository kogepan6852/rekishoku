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
         people.push(person)
      end
    end
    return people
  end

  def get_check_people(check_people)
    people = Array.new()
    check_people.each do |person|
      if person[:rating] != 0.0
         people.push(person)
      end
    end

    ## 連想配列のキーでの降順処理
    people.sort! do |a, b|
      b[:rating] <=> a[:rating]
    end

    return people
  end

  def get_shop_json(shop)
    # shopsに紐付いてる人物を取得する
    people = get_people(shop)
    # shopsに紐付けしている時代を取得をする
    periods = get_periods(shop.people)
    # 歴食度の設定
    rating = cal_rating(shop)
    # 価格帯の取得
    price = get_price(shop)
    # 返却用のオブジェクトを作成する
    obj = { "shop" => shop,
            "categories" => shop.categories,
            "people" => people.uniq,
            "periods" => periods.uniq,
            "rating" => rating,
            "price" => price
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
    type = Array.new()
    periods = Array.new()
    people = Array.new()

    feature.feature_details.each do |feature_detail|
      type.push(feature_detail[:related_type])
    end

    if type.include?("Shop")
      shops = Shop.joins(:feature_details).where('feature_id = ? ', feature[:id])
      people += get_people_feature(shops)
    end
    if type.include?("Post")
      posts = Post.joins(:feature_details).where('feature_id = ? ', feature[:id])
      people += get_people_feature(posts)
    end
    if type.include?("ExternalLink")
      extrnal_links = ExternalLink.joins(:feature_details).where('feature_id = ? ', feature[:id])
      people += get_people_feature(extrnal_links)
    end
    periods += get_periods(people)
    people = get_check_people(people)

    # 返却用のオブジェクトを作成する
    obj = {
            "feature" => feature,
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
