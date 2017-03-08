class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.integer  "invoice_id"
      t.date     "start_date"
      t.date     "end_date"
      t.integer  "nights"
      t.integer  "guests"
      t.text     "comments"
      t.integer  "qty"
      t.integer  "price_cents"
      t.float    "discount"
      t.boolean  "is_selected"
      t.belongs_to :invoice, index: true
      t.belongs_to :room, index: true
      t.timestamps
    end
  end
end
