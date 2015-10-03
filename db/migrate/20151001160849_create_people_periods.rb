class CreatePeoplePeriods < ActiveRecord::Migration
  def change
    create_table :people_periods, id: false do |t|
      t.integer :person, index: true, null: false
      t.integer :periods, index: true, null: false
    end
  end
end
