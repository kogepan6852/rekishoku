class PeoplePeriod < ActiveRecord::Base
  belongs_to :person
  belongs_to :period
end
