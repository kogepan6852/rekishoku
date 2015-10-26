json.array!(@people_posts) do |people_post|
  json.extract! people_post, :id, :person_id, :post_id
  json.url people_post_url(people_post, format: :json)
end
