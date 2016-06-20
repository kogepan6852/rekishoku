class ChangeRatingToPeople < ActiveRecord::Migration
  #変更後の型
  def up
    change_column :people, :rating, :float, null: false
  end

  #変更前の型
  def down
    change_column :people, :rating, :integer, default: 0, null: false
  end
end
