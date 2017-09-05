class CreateExternalLinks < ActiveRecord::Migration
  def change
    create_table :external_links do |t|
      t.string :image,                         null: true
      t.string :quotation_url
      t.float  :latitude
      t.float  :longitude
      t.timestamps 　　　　　　　　　　　　　　　　　　　null: false
    end

    reversible do |dir|
      dir.up do
        ExternalLink.create_translation_table! :name => {:type => :string, :null => false},
        :content => :text,
        :quotation_name => :string,
        :province => :string,
        :city => :string,
        :address1 => :string,
        :address2 => :string
      end
      dir.down do
        ExternalLink.drop_translation_table!
      end
    end
  end
end
