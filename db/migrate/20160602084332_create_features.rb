class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string   "title",                          null: false
      t.text     "content"
      t.string   "image",                          null: false
      t.string   "quotation_url"
      t.string   "quotation_name"
      t.boolean  "is_map",         default: false
      t.integer  "category_id",    default: 0,     null: false
      t.integer  "status",         default: 0,     null: false
      t.integer  "user_id",                        null: false
      t.timestamps                                 null: false
      t.datetime "published_at"
    end
  end
end
