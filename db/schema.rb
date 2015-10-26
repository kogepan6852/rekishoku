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

ActiveRecord::Schema.define(version: 20151014161135) do

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

  create_table "people", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "furigana"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",                      null: false
    t.text     "content"
    t.string   "image",                      null: false
    t.integer  "favorite_count", default: 0, null: false
    t.integer  "status",         default: 0, null: false
    t.integer  "user_id",                    null: false
    t.string   "quotation_url"
    t.string   "quotation_name"
    t.integer  "category_id",    default: 0, null: false
    t.text     "memo"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "posts_shops", id: false, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "shop_id", null: false
  end

  add_index "posts_shops", ["post_id"], name: "index_posts_shops_on_post_id", using: :btree
  add_index "posts_shops", ["shop_id"], name: "index_posts_shops_on_shop_id", using: :btree

  create_table "shops", force: :cascade do |t|
    t.string   "name",                 null: false
    t.text     "description"
    t.string   "url"
    t.text     "menu"
    t.string   "image",                null: false
    t.string   "subimage"
    t.string   "image_quotation_url"
    t.string   "image_quotation_name"
    t.string   "post_quotation_url"
    t.string   "post_quotation_name"
    t.string   "address1"
    t.string   "address2"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "categories_people", "categories"
  add_foreign_key "categories_people", "people"
  add_foreign_key "categories_shops", "categories"
  add_foreign_key "categories_shops", "shops"
  add_foreign_key "people_periods", "people"
  add_foreign_key "people_periods", "periods"
  add_foreign_key "people_posts", "people"
  add_foreign_key "people_posts", "posts"
  add_foreign_key "posts_shops", "posts"
  add_foreign_key "posts_shops", "shops"
end
