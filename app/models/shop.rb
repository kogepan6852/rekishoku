class Shop < ActiveRecord::Base
  has_and_belongs_to_many :categories
  mount_uploader :image, ImageUploader
  mount_uploader :subimage, ImageUploader
end
