class PostsShop < ActiveRecord::Base
  belongs_to :post
  belongs_to :shop
end
