class CreateExternalLinks < ActiveRecord::Migration
  def change
    create_table :external_links do |t|
      t.string   "title"
      t.text     "content"
      t.string   "image",                          null: false
      t.string   "quotation_url"
      t.string   "quotation_name"
      t.timestamps 　　　　　　　　　　　　　　　　　　　null: false
    end
  end
end
