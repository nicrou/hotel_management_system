class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string   "building"
      t.integer  "floor"
      t.integer  "number"
      t.text     "notes"
      t.belongs_to :category, index: true
      t.timestamps
    end
  end
end
