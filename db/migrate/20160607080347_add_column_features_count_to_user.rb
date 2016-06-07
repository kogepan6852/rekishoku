class AddColumnFeaturesCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :features_count, :integer, default: 0, null: false, :after => :role
  end
end
