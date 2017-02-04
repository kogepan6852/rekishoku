# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170106120654) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_people", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "person_id",   null: false
  end

  add_index "categories_people", ["category_id"], name: "index_categories_people_on_category_id", using: :btree
  add_index "categories_people", ["person_id"], name: "index_categories_people_on_person_id", using: :btree

  create_table "categories_shops", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "shop_id",     null: false
  end

  add_index "categories_shops", ["category_id"], name: "index_categories_shops_on_category_id", using: :btree
  add_index "categories_shops", ["shop_id"], name: "index_categories_shops_on_shop_id", using: :btree

  create_table "external_links", force: :cascade do |t|
    t.string   "name",           null: false
    t.text     "content"
    t.string   "image"
    t.string   "quotation_url"
    t.string   "quotation_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "province"
    t.string   "city"
    t.string   "address1"
    t.string   "address2"
    t.float    "latitude"
    t.float    "longitude"
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

  create_table "feature_details", force: :cascade do |t|
    t.integer  "feature_id"
    t.string   "title"
    t.text     "content"
    t.string   "related_type"
    t.integer  "related_id",   default: 0
    t.integer  "order",        default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "features", force: :cascade do |t|
    t.string   "title",                          null: false
    t.text     "content"
    t.string   "image",                          null: false
    t.string   "quotation_url"
    t.string   "quotation_name"
    t.boolean  "is_map",         default: false
    t.integer  "category_id",    default: 0,     null: false
    t.integer  "status",         default: 0,     null: false
    t.integer  "user_id",                        null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "published_at"
  end

  create_table "people", force: :cascade do |t|
    t.string   "name",                     null: false
    t.string   "furigana"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.float    "rating",     default: 0.0, null: false
  end

  create_table "people_external_links", id: false, force: :cascade do |t|
    t.integer "person_id",        null: false
    t.integer "external_link_id", null: false
  end

  add_index "people_external_links", ["external_link_id"], name: "index_people_external_links_on_external_link_id", using: :btree
  add_index "people_external_links", ["person_id"], name: "index_people_external_links_on_person_id", using: :btree

  create_table "people_features", force: :cascade do |t|
    t.integer "person_id",  null: false
    t.integer "feature_id", null: false
  end

  add_index "people_features", ["feature_id"], name: "index_people_features_on_feature_id", using: :btree
  add_index "people_features", ["person_id"], name: "index_people_features_on_person_id", using: :btree

  create_table "people_periods", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "period_id", null: false
  end

  add_index "people_periods", ["period_id"], name: "index_people_periods_on_period_id", using: :btree
  add_index "people_periods", ["person_id"], name: "index_people_periods_on_person_id", using: :btree

  create_table "people_posts", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "post_id",   null: false
  end

  add_index "people_posts", ["person_id"], name: "index_people_posts_on_person_id", using: :btree
  add_index "people_posts", ["post_id"], name: "index_people_posts_on_post_id", using: :btree

  create_table "people_shops", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "shop_id",   null: false
  end

  add_index "people_shops", ["person_id"], name: "index_people_shops_on_person_id", using: :btree
  add_index "people_shops", ["shop_id"], name: "index_people_shops_on_shop_id", using: :btree

  create_table "periods", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_details", force: :cascade do |t|
    t.integer  "post_id"
    t.string   "title"
    t.string   "image"
    t.text     "content"
    t.string   "quotation_url"
    t.string   "quotation_name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "is_eye_catch",   default: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",                          null: false
    t.text     "content"
    t.string   "image",                          null: false
    t.integer  "favorite_count", default: 0,     null: false
    t.integer  "status",         default: 0,     null: false
    t.integer  "user_id",                        null: false
    t.string   "quotation_url"
    t.string   "quotation_name"
    t.integer  "category_id",    default: 0,     null: false
    t.text     "memo"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "published_at"
    t.boolean  "is_eye_catch",   default: false
  end

  create_table "posts_shops", id: false, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "shop_id", null: false
  end

  add_index "posts_shops", ["post_id"], name: "index_posts_shops_on_post_id", using: :btree
  add_index "posts_shops", ["shop_id"], name: "index_posts_shops_on_shop_id", using: :btree

  create_table "prices", force: :cascade do |t|
    t.integer  "min"
    t.integer  "max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "name",                                 null: false
    t.text     "description"
    t.string   "url"
    t.text     "menu"
    t.string   "image",                                null: false
    t.string   "subimage"
    t.string   "image_quotation_url"
    t.string   "image_quotation_name"
    t.string   "post_quotation_url"
    t.string   "post_quotation_name"
    t.string   "province"
    t.string   "city"
    t.string   "address1"
    t.string   "address2"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "posts_shops_count",    default: 0,     null: false
    t.string   "phone_no"
    t.integer  "daytime_price_id"
    t.integer  "nighttime_price_id"
    t.text     "shop_hours"
    t.boolean  "is_closed_sun",        default: false, null: false
    t.boolean  "is_closed_mon",        default: false, null: false
    t.boolean  "is_closed_tue",        default: false, null: false
    t.boolean  "is_closed_wed",        default: false, null: false
    t.boolean  "is_closed_thu",        default: false, null: false
    t.boolean  "is_closed_fri",        default: false, null: false
    t.boolean  "is_closed_sat",        default: false, null: false
    t.boolean  "is_closed_hol",        default: false, null: false
    t.string   "closed_pattern"
    t.boolean  "is_approved",          default: false, null: false
    t.integer  "history_level",        default: 0
    t.integer  "building_level",       default: 0
    t.integer  "menu_level",           default: 0
    t.integer  "person_level",         default: 0
    t.integer  "episode_level",        default: 0
    t.integer  "total_level",          default: 0,     null: false
    t.integer  "period_id",            default: 0
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "posts_count",            default: 0,  null: false
    t.string   "uid"
    t.string   "provider"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "categories_people", "categories"
  add_foreign_key "categories_people", "people"
  add_foreign_key "categories_shops", "categories"
  add_foreign_key "categories_shops", "shops"
  add_foreign_key "people_external_links", "external_links"
  add_foreign_key "people_external_links", "people"
  add_foreign_key "people_features", "features"
  add_foreign_key "people_features", "people"
  add_foreign_key "people_periods", "people"
  add_foreign_key "people_periods", "periods"
  add_foreign_key "people_posts", "people"
  add_foreign_key "people_posts", "posts"
  add_foreign_key "people_shops", "people"
  add_foreign_key "people_shops", "shops"
  add_foreign_key "posts_shops", "posts"
  add_foreign_key "posts_shops", "shops"
end
