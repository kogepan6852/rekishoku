class ChangeImageToExternalLinks < ActiveRecord::Migration
  #変更後の型
  def up
    change_column :external_links, :image, :string, null: true
    change_column :external_links, :name, :string, null: false
  end

  #変更前の型
  def down
    change_column :external_links, :image, :string, null: false
    change_column :external_links, :name, :string
  end
end
