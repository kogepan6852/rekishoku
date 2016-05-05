class Shop < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  mount_uploader :subimage, ImageUploader

  has_and_belongs_to_many :posts
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :people
end
