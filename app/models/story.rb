class Story < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :period
  belongs_to :category
  belongs_to :user, :counter_cache => true
  has_and_belongs_to_many :shops, :join_table => "stories_shops"
  has_and_belongs_to_many :people
  has_many :story_details

  validates :title, presence: true
  validates :image, presence: true

  translates :title
  translates :content
  translates :quotation_name
  translates :memo
end
