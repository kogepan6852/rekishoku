class ExternalLink < ActiveRecord::Base
   mount_uploader :image, ImageUploader
   has_and_belongs_to_many :people, :join_table => "people_external_links"
   has_many :story_relations, :as => :related
   has_many :favorite_details, :as => :related


   translates :name
   translates :content
   translates :quotation_name
   translates :province
   translates :city
   translates :address1
   translates :address2
 end
