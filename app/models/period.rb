class Period < ActiveRecord::Base
  has_many :people_periods
  has_many :people, through: :people_periods
  has_and_belongs_to_many :people
end
