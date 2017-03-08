class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string   "title"
      t.string   "subtitle"
      t.text     "description"
      t.integer  "rooms_count"
      t.integer  "price_cents", default: 0
      t.float    "discount", default: 0
      t.text     "tags"
      t.string   "file_pathname"
      t.timestamps
    end
  end
end
