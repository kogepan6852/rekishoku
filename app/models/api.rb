class Api < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :people_period
  has_and_belongs_to_many :categories_people
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :categories_shops
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :people
  belongs_to :category
  has_many :people_periods
  has_many :periods, through: :people_periods
  belongs_to :post
  belongs_to :shop, :counter_cache => :posts_shops_count
  belongs_to :category
  belongs_to :person
  has_many :people_periods
  has_many :people, through: :people_periods
end
