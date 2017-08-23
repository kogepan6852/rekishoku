class CreatePostDetails < ActiveRecord::Migration
  def change
    create_table :story_details do |t|
      t.integer :story_id
      t.string :title
      t.string :image
      t.text :content
      t.string :quotation_url
      t.string :quotation_name
      t.boolean :is_eye_catch, default: false
      t.timestamps null: false
    end
  end
end
