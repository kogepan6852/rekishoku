class CreatePostDetails < ActiveRecord::Migration
  def change
    create_table :post_details do |t|
      t.integer :post_id
      t.string :title
      t.string :image
      t.text :content
      t.string :quotation_url
      t.string :quotation_name

      t.timestamps null: false
    end
  end
end
