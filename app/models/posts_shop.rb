class PostsShop < ActiveRecord::Base
  belongs_to :post
  belongs_to :shop, :counter_cache => :posts_shops_count
end
