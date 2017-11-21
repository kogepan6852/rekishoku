class CreateFavorites < ActiveRecord::Migration[4.2]
  def change
    create_table :favorites do |t|
      t.string   :name,                           null: false
      t.integer  :user_id,                        null: false
      t.integer  :order,         default: 0,      null: false
      t.boolean  :is_delete,     default: false
      t.timestamps                                 null: false
    end
  end
end
