class ChangePeriodToShops < ActiveRecord::Migration
  #変更後の型
  def up
    change_column :shops, :period_id, :integer
  end

  #変更前の型
  def down
    change_column :shops, :period_id, :integer, default: 0
  end
end
