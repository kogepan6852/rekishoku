class CreateCategoriesFeatures < ActiveRecord::Migration
  def change
    create_table :categories_features, id: false do |t|
      t.references :category, index: true, null: false
      t.references :feature, index: true, null: false
    end
        add_foreign_key :categories_features, :categories
        add_foreign_key :categories_features, :features
  end
end
