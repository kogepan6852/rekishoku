class CreateFavoriteDetails < ActiveRecord::Migration
  def change
    create_table :favorite_details do |t|
      t.integer  "favorite_id"
      t.string   "related_type"
      t.integer  "related_id",     default: 0
      t.timestamps                                 null: false
    end
  end
end
