class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text   :description
      t.timestamps :start_at,                   null: false
      t.timestamps :finish_at
      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        Event.create_translation_table! :name => {:type => :string, :null => false},
        :description => :text
      end
      dir.down do
        Event.drop_translation_table!
      end
    end
  end
end
