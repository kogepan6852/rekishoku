class StoryDetail < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :related, polymorphic: true
end
