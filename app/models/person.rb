class Person < ActiveRecord::Base
  has_many :posts, through: :people_posts
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :periods
  has_and_belongs_to_many :shops
end
