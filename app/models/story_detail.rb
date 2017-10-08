class StoryDetail < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :related, polymorphic: true
  belongs_to :category
  belongs_to :story


  translates :title
  translates :content
  translates :quotation_name
end
