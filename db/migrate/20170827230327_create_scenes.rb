class CreateScenes < ActiveRecord::Migration[5.0]
  def change
    create_table :scenes do |t|
      t.timestamps :start_at,                   null: false
      t.timestamps :finish_at
      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        Scene.create_translation_table! :name => {:type => :string, :null => false},
        :description => :text
      end
      dir.down do
        Scene.drop_translation_table!
      end
    end
  end
end
