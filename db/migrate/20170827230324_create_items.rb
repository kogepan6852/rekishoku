class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string   :name
      t.text   :description
      t.integer  :shop_id,                   null: false
      t.integer  :price
      t.integer  :pid
      t.timestamps                                 null: false
    end
  end
end
