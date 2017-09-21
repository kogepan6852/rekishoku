class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.float :rating
      t.string :image
      t.string :image_quotation_url
      t.integer :birth_year, default: 0
      t.integer :death_year, default: 0
      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        Person.create_translation_table! :name => {:type => :string, :null => false},
        :furigana => :string,
        :description => :text,
        :image_quotation_name => :string
      end
      dir.down do
        Person.drop_translation_table!
      end
    end
  end
end
