class CreateFavoriteDetails < ActiveRecord::Migration[4.2]
  def change
    create_table :favorite_details do |t|
      t.integer  :favorite_id
      t.string   :related_type,                   null: false
      t.integer  :related_id,                     null: false
      t.boolean  :is_delete,     default: false
      t.timestamps                                 null: false
    end
  end
end
