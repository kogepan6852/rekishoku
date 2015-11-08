class Person < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :people_period
  has_and_belongs_to_many :categories_people
  has_many :people_periods
  has_many :periods, through: :people_periods
end
