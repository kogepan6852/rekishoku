class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string   "title",                          null: false
      t.text     "content"
      t.string   "image",                          null: false
      t.boolean  "is_map",         default: false
      t.integer  "category_id",    default: 0,     null: false
      t.datetime "created_at",                     null: false
      t.datetime "updated_at",                     null: false
      t.datetime "published_at"
      t.integer  "status",         default: 0,     null: false
      t.integer  "user_id",                        null: false
    end
  end
end
