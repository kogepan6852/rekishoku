class CreatePeopleFeatures < ActiveRecord::Migration
  def change
    create_table :people_features do |t|
      t.references :person, index: true, null: false
      t.references :feature, index: true, null: false
      end
      add_foreign_key :people_features, :people
      add_foreign_key :people_features, :features
  end
end
