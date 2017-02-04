class Favorite < ActiveRecord::Base
  has_many :favorite_details
  belongs_to :user
end
