class PeoplePost < ActiveRecord::Base
  belongs_to :person
  belongs_to :post
end
