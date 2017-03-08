class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string   "code"
      t.boolean  "is_paid"
      t.integer  "total_cents"
      t.belongs_to :customer, index: true
      t.timestamps
    end
  end
end
