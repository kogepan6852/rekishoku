class ExternalLink < ActiveRecord::Base
   mount_uploader :image, ImageUploader
   has_many :feature_details, :as => :related
 end
