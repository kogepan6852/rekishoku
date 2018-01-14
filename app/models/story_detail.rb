class StoryDetail < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :story
  has_many :story_relations


  translates :title
  translates :content
  translates :quotation_name
  accepts_nested_attributes_for :translations, allow_destroy: true
end
