class AddColumnIsEyeCatchToPostDetails < ActiveRecord::Migration
  def change
    add_column :post_details, :is_eye_catch, :boolean, default: false
  end
end
