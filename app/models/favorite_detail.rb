class FavoriteDetail < ActiveRecord::Base
  belongs_to :favorite
  belongs_to :related, polymorphic: true
end
