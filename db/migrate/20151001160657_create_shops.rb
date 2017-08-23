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
      t.string :province
      t.string :city
      t.string :address1
      t.string :address2
      t.float :latitude
      t.float :longitude
      t.string :phone_no
      t.integer :daytime_price_id
      t.integer :nighttime_price_id
      t.text :shop_hours
      t.boolean :is_closed_sun, default: false, null: false
      t.boolean :is_closed_mon, default: false, null: false
      t.boolean :is_closed_tue, default: false, null: false
      t.boolean :is_closed_wed, default: false, null: false
      t.boolean :is_closed_thu, default: false, null: false
      t.boolean :is_closed_fri, default: false, null: false
      t.boolean :is_closed_sat, default: false, null: false
      t.boolean :is_closed_hol, default: false, null: false
      t.string  :closed_pattern
      t.integer :period_id, null: false, default: 0
      t.integer :history_level, default: 0
      t.integer :building_level, default: 0
      t.integer :person_level, default: 0
      t.integer :episode_level, default: 0
      t.integer :total_level, default: 0, null: false
      t.boolean :is_approved, default: false, null: false
      t.integer :stories_shops_count
      t.timestamps null: false
    end
  end
end
