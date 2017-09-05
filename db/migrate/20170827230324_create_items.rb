class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.integer  :shop_id,                   null: false
      t.integer  :price
      t.integer  :pid
      t.timestamps                                 null: false
    end

    reversible do |dir|
      dir.up do
        Item.create_translation_table! :name => {:type => :string, :null => false},
        :description => :text
      end
      dir.down do
        Item.drop_translation_table!
      end
    end
  end
end
