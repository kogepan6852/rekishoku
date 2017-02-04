class Post < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :category
  belongs_to :user, :counter_cache => true
  has_many :feature_details
  has_many :post_details
  has_many :feature_details, :as => :related
  has_many :favorite_details, :as => :related
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :people

  validates :title, presence: true
  validates :image, presence: true
end
