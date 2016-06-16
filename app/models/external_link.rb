class ExternalLink < ActiveRecord::Base
   mount_uploader :image, ImageUploader
   has_many :feature_details, :as => :related
   has_and_belongs_to_many :people, :join_table => "people_external_links"
 end
