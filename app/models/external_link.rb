class ExternalLink < ActiveRecord::Base
  mount_uploader :image, ImageUploader
end
