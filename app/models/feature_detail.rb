class FeatureDetail < ActiveRecord::Base
  belongs_to :feature
  has_and_belongs_to_many :external_links
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :shops
end
