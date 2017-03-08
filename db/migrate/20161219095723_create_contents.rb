class CreateContents < ActiveRecord::Migration[5.0]
  def change
    create_table :contents do |t|
      t.string   "title"
      t.text     "content"
      t.string   "locale"
      t.integer  "position", default: 0
      t.boolean  "is_index", default: false

      t.timestamps
    end
  end
end
