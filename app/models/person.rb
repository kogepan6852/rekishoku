class Person < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :periods
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :external_links, :join_table => "people_external_links"

  translates :furigana
  translates :description
  translates :image_quotation_name
end
