class FeatureDetail < ActiveRecord::Base
  belongs_to :feature
  has_many :shops
  has_many :posts
  has_many :external_links
end
