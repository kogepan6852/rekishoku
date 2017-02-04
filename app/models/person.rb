class Person < ActiveRecord::Base
  has_many :posts, through: :people_posts
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :periods
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :features, :join_table => "people_features"
  has_and_belongs_to_many :external_links, :join_table => "people_external_links"
end
