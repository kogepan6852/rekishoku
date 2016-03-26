class AddColumnAboutShopInfoToShops < ActiveRecord::Migration
  def change
    add_column :shops, :phone_no, :string
    add_column :shops, :daytime_price_id, :integer
    add_column :shops, :nighttime_price_id, :integer
    add_column :shops, :open_time, :string
    add_column :shops, :close_time, :string
    add_column :shops, :is_closed_sun, :boolean, default: false, null: false
    add_column :shops, :is_closed_mon, :boolean, default: false, null: false
    add_column :shops, :is_closed_tue, :boolean, default: false, null: false
    add_column :shops, :is_closed_wed, :boolean, default: false, null: false
    add_column :shops, :is_closed_thu, :boolean, default: false, null: false
    add_column :shops, :is_closed_fri, :boolean, default: false, null: false
    add_column :shops, :is_closed_sat, :boolean, default: false, null: false
    add_column :shops, :closed_pattern, :string
    add_column :shops, :is_approved, :boolean, default: false, null: false
  end
end
