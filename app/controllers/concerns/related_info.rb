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

    return periods
  end

  # 対象のお店から紐づく人物を取得する
  def get_people_reports(reports)
    people = Array.new()
    reports.each do |report|
      report.people.each do |person|
        people.push(person)
      end
    end
    return people
  end

  # 対象のお店から紐づく人物を取得する
  def get_people(report)
    people = Array.new()
      report.people.each do |person|
        people.push(person)
      end

    return people
  end

  def shops_show(feature_detail)
    # 対応するお店を取得する
    shop = Shop.find(feature_detail[:related_id])
    # shopsに紐付いてる人物を取得する
    people = get_people(shop)
    # shopsに紐付けしている時代を取得をする
    periods = get_periods(people)
    # 歴食度の設定
    rating = cal_rating(shop)
    # 価格帯の取得
    price = get_price(shop)
    obj = { "feature_detail" => feature_detail,
            "shop" => shop,
            "categories" => shop.categories,
            "people" => shop.people,
            "periods" => periods,
            "rating" => rating,
            "price" => price
          }
    return obj
  end

  def posts_show(feature_detail)
    # 対応するPostを取得する
    post = Post.find(feature_detail[:related_id])
    # postsに紐付いてる人物を取得する
    people = get_people(post)
    # postsに紐付けしている時代を取得をする
    periods = get_periods(people)

    # 返却用のオブジェクトを作成する
    obj = { "feature_detail" => feature_detail,
            "post" => post,
            "people" => post.people,
            "periods" => periods.uniq
          }
    return obj
  end

end
