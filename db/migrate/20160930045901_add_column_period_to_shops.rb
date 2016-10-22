class AddColumnPeriodToShops < ActiveRecord::Migration
  def change
    add_column :shops, :period_id, :integer, default: 0
  end
end
