class CreateAddressBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :address_books do |t|
      t.string :name
      t.string :tel

      t.timestamps
    end
  end
end
