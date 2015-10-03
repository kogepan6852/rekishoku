class CreateCategoriesPeople < ActiveRecord::Migration
  def change
    create_table :categories_people, id: false do |t|
      t.integer :category, index: true, null: false
      t.integer :person, index: true, null: false
    end
  end
end
