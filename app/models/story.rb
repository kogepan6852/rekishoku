class Story < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :user, :counter_cache => true
  has_many :post_details
  has_many :favorite_details, :as => :related
  has_and_belongs_to_many :shops

  validates :title, presence: true
  validates :image, presence: true
end
