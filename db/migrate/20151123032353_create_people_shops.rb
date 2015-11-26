class CreatePeopleShops < ActiveRecord::Migration
  def change
    create_table :people_shops, id: false do |t|
      t.references :person, index: true, null: false
      t.references :shop, index: true, null: false

    end
    add_foreign_key :people_shops, :people
    add_foreign_key :people_shops, :shops
  end
end
