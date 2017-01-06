class Feature < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :category
  has_many :feature_details
  belongs_to :user
  has_many :favorite_details, :as => :related
end
