class Feature < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :category
  has_many :feature_details
  belongs_to :user
  has_and_belongs_to_many :people, :join_table => "people_features"
end
