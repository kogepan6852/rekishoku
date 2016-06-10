class FeatureDetail < ActiveRecord::Base
  belongs_to :feature
  belongs_to :related, polymorphic: true
  mount_uploader :image, ImageUploader
end
