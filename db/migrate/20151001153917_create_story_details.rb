class CreateStoryDetails < ActiveRecord::Migration[4.2]
  def change
    create_table :story_details do |t|
      t.integer :story_id
      t.string :image
      t.string :quotation_url
      t.boolean :is_eye_catch, default: false
      t.integer :order
      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        StoryDetail.create_translation_table! :content => :text,
        :quotation_name => :string,
        :title => {:type => :string, :null => false}
      end

      dir.down do
        StoryDetail.drop_translation_table!
      end
    end
  end
end
