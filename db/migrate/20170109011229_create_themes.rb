class CreateThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :themes do |t|
      t.string "title"
      t.string "navbar"
      t.string "module"
      t.string "footer"
      t.string "content"
      t.boolean "selected"

      t.timestamps
    end
  end
end
