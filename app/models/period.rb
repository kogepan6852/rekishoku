class Period < ActiveRecord::Base
  has_and_belongs_to_many :people
  belongs_to :shop

end
