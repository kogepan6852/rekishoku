class StoriesShop < ActiveRecord::Base
  belongs_to :shop
  counter_culture :shop, touch: true
end
