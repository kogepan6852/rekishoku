class CreateCategoriesShops < ActiveRecord::Migration[4.2]
  def change
    create_table :categories_shops, id: false do |t|
      t.references :category, index: true, null: false
      t.references :shop, index: true, null: false
    end

        add_foreign_key :categories_shops, :categories
        add_foreign_key :categories_shops, :shops
  end
end
