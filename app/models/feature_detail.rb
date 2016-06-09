class FeatureDetail < ActiveRecord::Base
  belongs_to :feature
  has_many :shops
  has_many :posts
  mount_uploader :image, ImageUploader
end
