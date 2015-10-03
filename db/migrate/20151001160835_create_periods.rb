class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
