# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170827230334) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "address_books", force: :cascade do |t|
    t.string   "name"
    t.string   "tel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "slug"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_items", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "item_id",     null: false
    t.index ["category_id"], name: "index_categories_items_on_category_id", using: :btree
    t.index ["item_id"], name: "index_categories_items_on_item_id", using: :btree
  end

  create_table "categories_people", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "person_id",   null: false
    t.index ["category_id"], name: "index_categories_people_on_category_id", using: :btree
    t.index ["person_id"], name: "index_categories_people_on_person_id", using: :btree
  end

  create_table "categories_shops", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "shop_id",     null: false
    t.index ["category_id"], name: "index_categories_shops_on_category_id", using: :btree
    t.index ["shop_id"], name: "index_categories_shops_on_shop_id", using: :btree
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.index ["category_id"], name: "index_category_translations_on_category_id", using: :btree
    t.index ["locale"], name: "index_category_translations_on_locale", using: :btree
  end

  create_table "external_link_translations", force: :cascade do |t|
    t.integer  "external_link_id", null: false
    t.string   "locale",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "name",             null: false
    t.text     "content"
    t.string   "quotation_name"
    t.string   "province"
    t.string   "city"
    t.string   "address1"
    t.string   "address2"
    t.index ["external_link_id"], name: "index_external_link_translations_on_external_link_id", using: :btree
    t.index ["locale"], name: "index_external_link_translations_on_locale", using: :btree
  end

  create_table "external_links", force: :cascade do |t|
    t.string   "image"
    t.string   "quotation_url"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_details", force: :cascade do |t|
    t.integer  "favorite_id"
    t.string   "related_type",                 null: false
    t.integer  "related_id",                   null: false
    t.boolean  "is_delete",    default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.string   "name",                       null: false
    t.integer  "user_id",                    null: false
    t.integer  "order",      default: 0,     null: false
    t.boolean  "is_delete",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "item_translations", force: :cascade do |t|
    t.integer  "item_id",     null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name",        null: false
    t.text     "description"
    t.index ["item_id"], name: "index_item_translations_on_item_id", using: :btree
    t.index ["locale"], name: "index_item_translations_on_locale", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.integer  "shop_id",    null: false
    t.integer  "price"
    t.integer  "pid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "name",                            null: false
    t.float    "rating"
    t.string   "image"
    t.string   "image_quotation_url"
    t.integer  "birth_year",          default: 0
    t.integer  "death_year",          default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "people_external_links", id: false, force: :cascade do |t|
    t.integer "person_id",        null: false
    t.integer "external_link_id", null: false
    t.index ["external_link_id"], name: "index_people_external_links_on_external_link_id", using: :btree
    t.index ["person_id"], name: "index_people_external_links_on_person_id", using: :btree
  end

  create_table "people_periods", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "period_id", null: false
    t.index ["period_id"], name: "index_people_periods_on_period_id", using: :btree
    t.index ["person_id"], name: "index_people_periods_on_person_id", using: :btree
  end

  create_table "people_shops", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "shop_id",   null: false
    t.index ["person_id"], name: "index_people_shops_on_person_id", using: :btree
    t.index ["shop_id"], name: "index_people_shops_on_shop_id", using: :btree
  end

  create_table "people_stories", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "story_id",  null: false
    t.index ["person_id"], name: "index_people_stories_on_person_id", using: :btree
    t.index ["story_id"], name: "index_people_stories_on_story_id", using: :btree
  end

  create_table "period_translations", force: :cascade do |t|
    t.integer  "period_id",  null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name",       null: false
    t.index ["locale"], name: "index_period_translations_on_locale", using: :btree
    t.index ["period_id"], name: "index_period_translations_on_period_id", using: :btree
  end

  create_table "periods", force: :cascade do |t|
    t.integer  "order",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "person_translations", force: :cascade do |t|
    t.integer  "person_id",            null: false
    t.string   "locale",               null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "furigana"
    t.text     "description"
    t.string   "image_quotation_name"
    t.index ["locale"], name: "index_person_translations_on_locale", using: :btree
    t.index ["person_id"], name: "index_person_translations_on_person_id", using: :btree
  end

  create_table "prices", force: :cascade do |t|
    t.integer  "min"
    t.integer  "max"
    t.integer  "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scene_translations", force: :cascade do |t|
    t.integer  "scene_id",    null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name",        null: false
    t.text     "description"
    t.index ["locale"], name: "index_scene_translations_on_locale", using: :btree
    t.index ["scene_id"], name: "index_scene_translations_on_scene_id", using: :btree
  end

  create_table "scenes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scenes_items", id: false, force: :cascade do |t|
    t.integer "scene_id", null: false
    t.integer "item_id",  null: false
    t.index ["item_id"], name: "index_scenes_items_on_item_id", using: :btree
    t.index ["scene_id"], name: "index_scenes_items_on_scene_id", using: :btree
  end

  create_table "shop_translations", force: :cascade do |t|
    t.integer  "shop_id",              null: false
    t.string   "locale",               null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "name",                 null: false
    t.text     "description"
    t.text     "menu"
    t.text     "shop_hours"
    t.string   "image_quotation_name"
    t.string   "post_quotation_name"
    t.string   "closed_pattern"
    t.string   "province"
    t.string   "city"
    t.string   "address1"
    t.string   "address2"
    t.index ["locale"], name: "index_shop_translations_on_locale", using: :btree
    t.index ["shop_id"], name: "index_shop_translations_on_shop_id", using: :btree
  end

  create_table "shops", force: :cascade do |t|
    t.string   "url"
    t.text     "menu"
    t.string   "image",                               null: false
    t.string   "subimage"
    t.string   "image_quotation_url"
    t.string   "post_quotation_url"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "phone_no"
    t.integer  "daytime_price_id"
    t.integer  "nighttime_price_id"
    t.boolean  "is_closed_sun",       default: false, null: false
    t.boolean  "is_closed_mon",       default: false, null: false
    t.boolean  "is_closed_tue",       default: false, null: false
    t.boolean  "is_closed_wed",       default: false, null: false
    t.boolean  "is_closed_thu",       default: false, null: false
    t.boolean  "is_closed_fri",       default: false, null: false
    t.boolean  "is_closed_sat",       default: false, null: false
    t.boolean  "is_closed_hol",       default: false, null: false
    t.integer  "period_id",           default: 0,     null: false
    t.integer  "history_level",       default: 0
    t.integer  "building_level",      default: 0
    t.integer  "menu_level",          default: 0
    t.integer  "person_level",        default: 0
    t.integer  "episode_level",       default: 0
    t.integer  "total_level",         default: 0,     null: false
    t.boolean  "is_approved",         default: false, null: false
    t.integer  "stories_shops_count"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string   "image",                          null: false
    t.integer  "favorite_count", default: 0,     null: false
    t.integer  "status",         default: 0,     null: false
    t.integer  "user_id",                        null: false
    t.string   "quotation_url"
    t.integer  "category_id",    default: 0,     null: false
    t.text     "memo"
    t.boolean  "is_eye_catch",   default: false
    t.boolean  "is_map",         default: false
    t.datetime "published_at",                   null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "stories_shops", id: false, force: :cascade do |t|
    t.integer "story_id", null: false
    t.integer "shop_id",  null: false
    t.index ["shop_id"], name: "index_stories_shops_on_shop_id", using: :btree
    t.index ["story_id"], name: "index_stories_shops_on_story_id", using: :btree
  end

  create_table "story_detail_translations", force: :cascade do |t|
    t.integer  "story_detail_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "content"
    t.string   "quotation_name"
    t.string   "title",           null: false
    t.index ["locale"], name: "index_story_detail_translations_on_locale", using: :btree
    t.index ["story_detail_id"], name: "index_story_detail_translations_on_story_detail_id", using: :btree
  end

  create_table "story_details", force: :cascade do |t|
    t.integer  "story_id"
    t.string   "image"
    t.string   "quotation_url"
    t.boolean  "is_eye_catch",  default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "story_relations", force: :cascade do |t|
    t.integer  "story_id",                    null: false
    t.integer  "story_detail_id"
    t.string   "related_type",                null: false
    t.integer  "related_id",                  null: false
    t.integer  "order",           default: 1
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "story_translations", force: :cascade do |t|
    t.integer  "story_id",       null: false
    t.string   "locale",         null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "content"
    t.text     "memo"
    t.string   "quotation_name"
    t.string   "title",          null: false
    t.index ["locale"], name: "index_story_translations_on_locale", using: :btree
    t.index ["story_id"], name: "index_story_translations_on_story_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "username",               default: "", null: false
    t.text     "description"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "profile"
    t.string   "image"
    t.integer  "role",                   default: 1,  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "uid"
    t.string   "provider"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "posts_count",            default: 0,  null: false
  end

  add_foreign_key "categories_items", "categories"
  add_foreign_key "categories_items", "items"
  add_foreign_key "categories_people", "categories"
  add_foreign_key "categories_people", "people"
  add_foreign_key "categories_shops", "categories"
  add_foreign_key "categories_shops", "shops"
  add_foreign_key "people_external_links", "external_links"
  add_foreign_key "people_external_links", "people"
  add_foreign_key "people_periods", "people"
  add_foreign_key "people_periods", "periods"
  add_foreign_key "people_shops", "people"
  add_foreign_key "people_shops", "shops"
  add_foreign_key "people_stories", "people"
  add_foreign_key "people_stories", "stories"
  add_foreign_key "scenes_items", "items"
  add_foreign_key "scenes_items", "scenes"
  add_foreign_key "stories_shops", "shops"
  add_foreign_key "stories_shops", "stories"
end
