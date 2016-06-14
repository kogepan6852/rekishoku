class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  counter_culture :user
  has_many :post_details
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :people
  has_and_belongs_to_many :feature_details
  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :image, presence: true
end
