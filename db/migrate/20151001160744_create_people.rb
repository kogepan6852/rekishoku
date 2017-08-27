class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.string :furigana
      t.float :rating
      t.text :description
      t.string :image
      t.string :image_quotation_url
      t.string :image_quotation_name
      t.integer :birth_year, default: 0
      t.integer :death_year, default: 0
      t.timestamps null: false
    end
  end
end
