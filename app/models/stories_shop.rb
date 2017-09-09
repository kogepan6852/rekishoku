class StoriesShop < ActiveRecord::Base
  belongs_to :shop
  has_and_belongs_to_many :categories
  counter_culture :shop, touch: true
end
