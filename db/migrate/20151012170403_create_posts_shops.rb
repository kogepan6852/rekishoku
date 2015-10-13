class CreatePostsShops < ActiveRecord::Migration
  def change
    create_table :posts_shops, id: false do |t|
      t.references :post, index: true, null: false
      t.references :shop, index: true, null: false

    end
    add_foreign_key :posts_shops, :posts
    add_foreign_key :posts_shops, :shops
  end
end
