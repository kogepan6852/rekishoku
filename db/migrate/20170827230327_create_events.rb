class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text   :description
      t.timestamps :start_at,                   null: false
      t.timestamps :finish_at
      t.timestamps null: false
    end
  end
end
