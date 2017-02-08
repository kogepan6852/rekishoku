class AddFeatureColumnsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_map,  :boolean, default: false
  end
end
