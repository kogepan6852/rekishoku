class CreatePeriods < ActiveRecord::Migration[4.2]
  def change
    create_table :periods do |t|
      t.integer :order, default: 0
      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        Period.create_translation_table! :name => {:type => :string, :null => false}
      end
      dir.down do
        Period.drop_translation_table!
      end
    end

  end
end
