json.array!(@categories) do |category|
  json.extract! category, :id, :name, :slug, :type
  json.url category_url(category, format: :json)
end
