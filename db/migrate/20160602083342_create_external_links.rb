class CreateExternalLinks < ActiveRecord::Migration
  def change
    create_table :external_links do |t|
      t.string :name
      t.text   :content
      t.string :image,                         null: true
      t.string :quotation_url
      t.string :quotation_name
      t.string :province
      t.string :city
      t.string :address1
      t.string :address2
      t.float  :latitude
      t.float  :longitude
      t.timestamps 　　　　　　　　　　　　　　　　　　　null: false
    end
  end
end
