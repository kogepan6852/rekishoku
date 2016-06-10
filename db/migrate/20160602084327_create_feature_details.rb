class CreateFeatureDetails < ActiveRecord::Migration
  def change
    create_table :feature_details do |t|
      t.integer  "feature_id"
      t.string   "title",                          null: false
      t.integer  "related_type",   default: 0,     null: false
      t.integer  "related_id",                     null: false
      t.integer  "order",          default: 0,     null: false
      t.string   "external_link_title"
      t.text     "content"
      t.string   "image"
      t.string   "quotation_url"
      t.string   "quotation_name"
      t.boolean  "is_external_link",               default: false
      t.timestamps                                 null: false
    end
  end
end
