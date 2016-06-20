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

  def get_shop_json(shop)
    # shopsに紐付いてる人物を取得する
    people = get_people(shop)
    # shopsに紐付けしている時代を取得をする
    periods = get_periods(people)
    # 歴食度の設定
    rating = cal_rating(shop)
    # 価格帯の取得
    price = get_price(shop)

    people = people.where("rating != ?", 0.000000000)
    # 返却用のオブジェクトを作成する
    obj = { "shop" => shop,
            "categories" => shop.categories,
            "people" => people,
            "periods" => periods,
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
    periods = get_periods(people)

    # 返却用のオブジェクトを作成する
    obj = { "post" => postObj,
            "people" => post.people,
            "periods" => periods.uniq
          }
    return obj
  end

  private
    # 対象の記事/店舗/外部リンクから紐づく人物を取得する
    def get_people(report)
      people = Array.new()
        report.people.each do |person|
          people.push(person)
        end
      return people
    end

end
