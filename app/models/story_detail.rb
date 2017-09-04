class StoryDetail < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :related, polymorphic: true

  translates :title
  translates :content
  translates :quotation_name
end
