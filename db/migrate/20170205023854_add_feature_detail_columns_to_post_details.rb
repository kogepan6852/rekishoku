class AddFeatureDetailColumnsToPostDetails < ActiveRecord::Migration
  def change
    add_column :post_details, :related_type,  :string
    add_column :post_details, :related_id,  :integer
    add_column :post_details, :order,  :integer, default: 0, null: false
  end
end
