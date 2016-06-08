class CreateFeatureDetails < ActiveRecord::Migration
  def change
    create_table :feature_details do |t|
      t.integer  "feature_id"
      t.string   "title",                          null: false
      t.integer  "info_type",      default: 0,     null: false
      t.integer  "related_id",                     null: false
      t.integer  "order",          default: 0,     null: false
    end
  end
end
