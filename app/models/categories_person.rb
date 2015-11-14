class CategoriesPerson < ActiveRecord::Base
  belongs_to :category
  belongs_to :person
end
