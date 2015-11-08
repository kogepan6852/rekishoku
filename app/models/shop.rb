class Shop < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :categories_shops
  has_and_belongs_to_many :posts
  mount_uploader :image, ImageUploader
  mount_uploader :subimage, ImageUploader
end
