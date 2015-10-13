json.array!(@posts_shops) do |posts_shop|
  json.extract! posts_shop, :post_id, :shop_id
  json.url posts_shop_url(posts_shop, format: :json)
end
