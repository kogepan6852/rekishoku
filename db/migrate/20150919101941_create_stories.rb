class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :image, null: false
      t.integer :favorite_count, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :user_id, null: false
      t.string :quotation_url
      t.integer :category_id, null: false, default: 0
      t.text :memo
      t.boolean :is_eye_catch, default: false
      t.boolean :is_map, default: false
      t.timestamps null: false
      t.timestamps :published_at
    end

    reversible do |dir|
      dir.up do
        Story.create_translation_table! :content => :text,
        :memo => :text,
        :quotation_name => :string,
        :title => {:type => :string, :null => false}
      end

      dir.down do
        Story.drop_translation_table!
      end
    end
  end
end