class StoriesShop < ActiveRecord::Base
  belongs_to :story
  belongs_to :shop
end
