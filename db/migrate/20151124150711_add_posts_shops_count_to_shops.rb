class AddPostsShopsCountToShops < ActiveRecord::Migration
  def change
    add_column :shops, :posts_shops_count, :integer, default: 0, null: false
  end
end
