class CreateCategoriesPeople < ActiveRecord::Migration
  def change
    create_table :categories_people, id: false do |t|
      t.references :category, index: true, null: false
      t.references :person, index: true, null: false
    end
  end
end
