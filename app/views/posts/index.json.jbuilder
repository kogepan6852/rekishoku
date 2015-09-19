json.array!(@posts) do |post|
  json.extract! post, :id, :title, :content, :image, :favorite_count, :status, :user_id, :quotation_url, :quotation_name, :category_id
  json.url post_url(post, format: :json)
end
