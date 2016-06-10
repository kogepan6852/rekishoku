class CreateFeatureDetails < ActiveRecord::Migration
  def change
    create_table :feature_details do |t|
      t.integer  "feature_id"
      t.string   "title",                          null: false
      t.string   "related_type"
      t.integer  "related_id",     default: 0
      t.integer  "order",          default: 0,     null: false
      t.timestamps                                 null: false
    end
  end
end
