class CreatePeoplePeriods < ActiveRecord::Migration[4.2]
  def change
    create_table :people_periods, id: false do |t|
      t.references :person, index: true, null: false
      t.references :period, index: true, null: false
    end

    add_foreign_key :people_periods, :people
    add_foreign_key :people_periods, :periods
  end
end
