class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string   "title"
      t.string   "forename"
      t.string   "surname"
      t.string   "v_title"
      t.string   "v_forename"
      t.string   "v_surname"
      t.string   "v_surname"
      t.string   "identification_credential"
      t.string   "mobile_phone"
      t.string   "email"
      t.string   "reason"
      t.text     "notes"
      t.timestamps
    end
  end
end
