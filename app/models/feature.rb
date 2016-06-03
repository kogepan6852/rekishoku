class Feature < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :category
  has_many :feature_details
  belongs_to :user
  counter_culture :user
end
