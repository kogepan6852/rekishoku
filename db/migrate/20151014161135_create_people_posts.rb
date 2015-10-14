class CreatePeoplePosts < ActiveRecord::Migration
  def change
    create_table :people_posts, id: false do |t|
      t.references :person, index: true, null: false
      t.references :post, index: true, null: false

    end
    add_foreign_key :people_posts, :people
    add_foreign_key :people_posts, :posts
  end
end
