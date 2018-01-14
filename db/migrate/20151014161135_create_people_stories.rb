class CreatePeopleStories < ActiveRecord::Migration[4.2]
  def change
    create_table :people_stories, id: false do |t|
      t.references :person, index: true, null: false
      t.references :story, index: true, null: false

    end
    add_foreign_key :people_stories, :people
    add_foreign_key :people_stories, :stories
  end
end
