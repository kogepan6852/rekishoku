class PeopleShop < ActiveRecord::Base
  belongs_to :person
  belongs_to :shop
end
