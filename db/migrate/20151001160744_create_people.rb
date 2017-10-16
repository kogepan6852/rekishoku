class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.float :rating
      t.integer :birth_year, default: 0
      t.integer :death_year, default: 0
      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        Person.create_translation_table! :furigana => :string
      end
      dir.down do
        Person.drop_translation_table!
      end
    end
  end
end
