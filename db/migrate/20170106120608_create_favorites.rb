class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer  "user_id",                        null: false
      t.integer  "order",         default: 0,     null: false
      t.string   "file_name",      default: "ファイル名", null: false
      t.timestamps                                 null: false
    end
  end
end
