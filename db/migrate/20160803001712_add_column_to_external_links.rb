class AddColumnToExternalLinks < ActiveRecord::Migration
  def change
    add_column :external_links, :province,  :string
    add_column :external_links, :city,  :string
    add_column :external_links, :address1,  :string
    add_column :external_links, :address2,  :string
    add_column :external_links, :latitude,  :float
    add_column :external_links, :longitude,  :float
  end
end
