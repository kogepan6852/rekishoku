class AddColumnIsEyeCatchToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_eye_catch, :boolean, default: false
  end
end
