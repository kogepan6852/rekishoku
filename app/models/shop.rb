class Shop < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  mount_uploader :subimage, ImageUploader
  belongs_to :period
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :stories, :join_table => "stories_shops"
  has_and_belongs_to_many :people
  has_many :favorite_details, :as => :related
  has_many :story_relations, :as => :related
  belongs_to :daytime_price, :class_name => 'Price', :foreign_key => 'daytime_price_id'
  belongs_to :nighttime_price, :class_name => 'Price', :foreign_key => 'nighttime_price_id'

  translates :name
  translates :description
  translates :menu
  translates :shop_hours
  translates :image_quotation_name
  translates :post_quotation_name
  translates :closed_pattern
  translates :province
  translates :city
  translates :address1
  translates :address2
  accepts_nested_attributes_for :translations, allow_destroy: true
end
