json.array!(@post_details) do |post_detail|
  json.extract! post_detail, :id, :post_id, :title, :image, :content, :quotation_url, :quotation_name
  json.url post_detail_url(post_detail, format: :json)
end
