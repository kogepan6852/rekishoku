class StoryDetail < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :story
  has_many :story_relations


  translates :title
  translates :content
  translates :quotation_name
end
