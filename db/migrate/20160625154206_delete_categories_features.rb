class DeleteCategoriesFeatures < ActiveRecord::Migration
  def change
    drop_table :categories_features
  end
end
