class AddColumnRekishokuLevelToShops < ActiveRecord::Migration
  def change
    add_column :shops, :history_level,  :integer, default: 0
    add_column :shops, :building_level, :integer, default: 0
    add_column :shops, :menu_level,     :integer, default: 0
    add_column :shops, :person_level,   :integer, default: 0
    add_column :shops, :episode_level,  :integer, default: 0
    add_column :shops, :total_level,    :integer, default: 0, null: false
  end
end
