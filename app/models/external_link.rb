class ExternalLink < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :feature_details
end
