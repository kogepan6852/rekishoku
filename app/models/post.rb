class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_and_belongs_to_many :shops
  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :image, presence: true
end
