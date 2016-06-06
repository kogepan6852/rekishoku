class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :feature_details
  counter_culture :user
  has_many :post_details
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :people
  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :image, presence: true
end
