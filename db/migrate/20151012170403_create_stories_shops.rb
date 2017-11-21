class CreateStoriesShops < ActiveRecord::Migration[4.2]
  def change
    create_table :stories_shops, id: false do |t|
      t.references :story, index: true, null: false
      t.references :shop, index: true, null: false

    end
    add_foreign_key :stories_shops, :stories
    add_foreign_key :stories_shops, :shops
  end
end
