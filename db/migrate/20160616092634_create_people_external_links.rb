class CreatePeopleExternalLinks < ActiveRecord::Migration
  def change
    create_table :people_external_links, id: false do |t|
      t.references :person, index: true, null: false
      t.references :external_link, index: true, null: false
    end
    add_foreign_key :people_external_links, :people
    add_foreign_key :people_external_links, :external_links
  end
end
