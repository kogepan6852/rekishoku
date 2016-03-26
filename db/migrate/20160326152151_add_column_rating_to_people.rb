class AddColumnRatingToPeople < ActiveRecord::Migration
  def change
    add_column :people, :rating, :integer, default: 0, null: false
  end
end
