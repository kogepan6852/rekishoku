json.array!(@shops) do |shop|
  json.extract! shop, :id, :name, :description, :image, :subimage, :image_quotation_url, :image_quotation_name, :post_quotation_url, :post_quotation_name, :province, :city, :address1, :address2, :latitude, :longitude, :menu
  json.url shop_url(shop, format: :json)
end
