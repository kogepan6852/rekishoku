class Category < ActiveRecord::Base
  has_and_belongs_to_many :people
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :stories

  translates :name
end
