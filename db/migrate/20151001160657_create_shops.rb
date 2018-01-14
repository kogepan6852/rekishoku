class CreateShops < ActiveRecord::Migration[4.2]
  def change
    create_table :shops do |t|
      t.string :url
      t.text :menu
      t.string :image, null: false
      t.string :subimage
      t.string :image_quotation_url
      t.string :post_quotation_url
      t.float :latitude
      t.float :longitude
      t.string :phone_no
      t.integer :daytime_price_id
      t.integer :nighttime_price_id
      t.boolean :is_closed_sun, default: false, null: false
      t.boolean :is_closed_mon, default: false, null: false
      t.boolean :is_closed_tue, default: false, null: false
      t.boolean :is_closed_wed, default: false, null: false
      t.boolean :is_closed_thu, default: false, null: false
      t.boolean :is_closed_fri, default: false, null: false
      t.boolean :is_closed_sat, default: false, null: false
      t.boolean :is_closed_hol, default: false, null: false
      t.integer :period_id, null: false, default: 0
      t.integer :history_level, default: 0
      t.integer :building_level, default: 0
      t.integer :menu_level, default: 0
      t.integer :person_level, default: 0
      t.integer :episode_level, default: 0
      t.integer :total_level, default: 0, null: false
      t.boolean :is_approved, default: false, null: false
      t.integer :stories_shops_count
      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        Shop.create_translation_table! :name => {:type => :string, :null => false},
        :description => :text,
        :menu => :text,
        :shop_hours => :text,
        :image_quotation_name => :string,
        :post_quotation_name => :string,
        :closed_pattern => :string,
        :province => :string,
        :city => :string,
        :address1 => :string,
        :address2 => :string
      end
      dir.down do
        Shop.drop_translation_table!
      end
    end
  end
end
