class Post < ActiveRecord::Base
  belongs_to :category
  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :image, presence: true
end
