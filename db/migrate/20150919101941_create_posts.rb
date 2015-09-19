class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :image
      t.integer :favorite_count
      t.integer :status
      t.integer :user_id
      t.string :quotation_url
      t.string :quotation_name
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
