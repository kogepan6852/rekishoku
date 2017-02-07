class PostDetail < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :post
  belongs_to :related, polymorphic: true
end
