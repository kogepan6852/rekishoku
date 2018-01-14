class Story < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :category
  belongs_to :user, :counter_cache => true
  has_and_belongs_to_many :shops, :join_table => "stories_shops"
  has_and_belongs_to_many :people
  has_many :story_translation
  has_many :story_details
  has_many :story_relations
  has_many :story_relations, :as => :related
  has_many :favorite_details, :as => :related

  validates :title, presence: true
  validates :image, presence: true

  translates :title
  translates :content
  translates :quotation_name
  translates :memo
  accepts_nested_attributes_for :translations, allow_destroy: true
end
