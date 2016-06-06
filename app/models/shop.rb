class Shop < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  mount_uploader :subimage, ImageUploader

  has_and_belongs_to_many :posts
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :people
  has_many :feature_details
  belongs_to :daytime_price, :class_name => 'Price', :foreign_key => 'daytime_price_id'
  belongs_to :nighttime_price, :class_name => 'Price', :foreign_key => 'nighttime_price_id'
end
