class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :min
      t.integer :max

      t.timestamps null: false
    end
  end
end
