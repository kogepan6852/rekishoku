class CreateCategoriesPeople < ActiveRecord::Migration[4.2]
  def change
    create_table :categories_people, id: false do |t|
      t.references :category, index: true, null: false
      t.references :person, index: true, null: false
    end

        add_foreign_key :categories_people, :categories
        add_foreign_key :categories_people, :people
  end
end
