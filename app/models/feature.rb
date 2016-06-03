class Feature < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :category
  belongs_to :feature_detail
end
