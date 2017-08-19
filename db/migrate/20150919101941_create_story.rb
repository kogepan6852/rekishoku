class CreatePosts < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title, null: false
      t.text :content
      t.string :image, null: false
      t.integer :favorite_count, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :user_id, null: false
      t.string :quotation_url
      t.string :quotation_name
      t.integer :category_id, null: false, default: 0
      t.text :memo
      t.boolean :is_eye_catch, default: false
      t.boolean :is_map, default: false
      t.timestamps :published_at
      t.timestamps null: false
    end
  end
end
