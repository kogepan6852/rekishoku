json.array!(@periods) do |period|
  json.extract! period, :id, :name
  json.url period_url(period, format: :json)
end
