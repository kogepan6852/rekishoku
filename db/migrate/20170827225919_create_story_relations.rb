class CreateStoryRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :story_relations do |t|
      t.integer  :story_detail_id
      t.string   :related_type,                   null: false
      t.integer  :related_id,                     null: false
      t.integer  :order,     default: 1
      t.timestamps                                 null: false
    end
  end
end
