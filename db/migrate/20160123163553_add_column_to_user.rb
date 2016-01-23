class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :posts_count, :integer, default: 0, null: false, :after => :role
    add_column :users, :uid, :string, :after => :authentication_token
    add_column :users, :provider, :string, :after => :authentication_token
  end
end
