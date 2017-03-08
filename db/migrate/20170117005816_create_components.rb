class CreateComponents < ActiveRecord::Migration[5.0]
  def change
    create_table :components do |t|
      t.string   "title"
      t.text     "content"
      t.integer  "position", default: 0
      t.string   "collection_directory"
      t.boolean  "is_slider", default: false
      t.boolean  "is_map", default: false
      t.boolean  "is_social_link", default: false
      t.boolean  "is_editable", default: true

      t.timestamps
    end
  end
end
