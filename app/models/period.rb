class Period < ActiveRecord::Base
  has_and_belongs_to_many :people
  has_many :shop

end
