class CreatePrices < ActiveRecord::Migration[4.2]
  def change
    create_table :prices do |t|
      t.integer :min
      t.integer :max
      t.integer :order
      t.timestamps null: false
    end
  end
end
