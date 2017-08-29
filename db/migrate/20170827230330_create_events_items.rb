class CreateEventsItems < ActiveRecord::Migration[5.0]
  def change
    create_table :events_items , id: false do |t|
      t.references :event, index: true, null: false
      t.references :item, index: true, null: false
    end
    add_foreign_key :events_items, :events
    add_foreign_key :events_items, :items
  end
end
