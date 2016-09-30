class AddColumnPeriodToShops < ActiveRecord::Migration
  def change
    add_column :shops, :period, :integer, default: 0
  end
end
