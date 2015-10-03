class CreateCategoriesShops < ActiveRecord::Migration
  def change
    create_table :categories_shops, id: false do |t|
      t.references :category, index: true, null: false
      t.references :shop, index: true, null: false
    end
  end
end
