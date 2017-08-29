class CreateCategoriesItems < ActiveRecord::Migration[5.0]
  def change
    create_table :categories_items , id: false do |t|
      t.references :category, index: true, null: false
      t.references :item, index: true, null: false
    end
    add_foreign_key :categories_items, :categories
    add_foreign_key :categories_items, :items
  end
end
