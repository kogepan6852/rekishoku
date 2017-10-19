class StoryRelation < ActiveRecord::Base
  belongs_to :story
  belongs_to :story_detail
  belongs_to :related, polymorphic: true
end
