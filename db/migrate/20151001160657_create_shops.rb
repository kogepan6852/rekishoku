class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.text :description
      t.string :url
      t.text :menu
      t.string :image, null: false
      t.string :subimage
      t.string :image_quotation_url
      t.string :image_quotation_name
      t.string :post_quotation_url
      t.string :post_quotation_name
      t.string :address1
      t.string :address2
      t.float :latitude
      t.float :longitude
      t.string  :province
      t.string  :city


      t.timestamps null: false
    end
  end
end
