class PostsShop < ActiveRecord::Base
  belongs_to :post
  belongs_to :shop
  counter_culture :shop, touch: true
end
