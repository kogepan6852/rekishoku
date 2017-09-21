class CreateEventsItems < ActiveRecord::Migration[5.0]
  def change
    create_table :scenes_items , id: false do |t|
      t.references :scene, index: true, null: false
      t.references :item, index: true, null: false
    end
    add_foreign_key :scenes_items, :scenes
    add_foreign_key :scenes_items, :items
  end
end
