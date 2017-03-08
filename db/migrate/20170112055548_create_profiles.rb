class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.string   "forename"
      t.string   "surname"
      t.date     "date_of_birth"
      t.string   "country"
      t.string   "province"
      t.string   "city"
      t.string   "street"
      t.string   "postal_code"
      t.string   "home_phone"
      t.string   "mobile_phone"
      t.string   "role", default: "Employee"
      t.boolean  "admin", default: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
