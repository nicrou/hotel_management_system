# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170117081517) do

  create_table "bookings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "invoice_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "nights"
    t.integer  "guests"
    t.text     "comments",    limit: 65535
    t.integer  "qty"
    t.integer  "price_cents"
    t.float    "discount",    limit: 24
    t.boolean  "is_selected"
    t.integer  "room_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["invoice_id"], name: "index_bookings_on_invoice_id", using: :btree
    t.index ["room_id"], name: "index_bookings_on_room_id", using: :btree
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "description",   limit: 65535
    t.integer  "rooms_count"
    t.integer  "price_cents",                 default: 0
    t.float    "discount",      limit: 24,    default: 0.0
    t.text     "tags",          limit: 65535
    t.string   "file_pathname"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "components", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "title"
    t.text     "content",              limit: 65535
    t.integer  "position",                           default: 0
    t.string   "collection_directory"
    t.boolean  "is_slider",                          default: false
    t.boolean  "is_map",                             default: false
    t.boolean  "is_social_link",                     default: false
    t.boolean  "is_editable",                        default: true
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "components_contents", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "content_id"
    t.integer "component_id"
    t.index ["component_id"], name: "index_components_contents_on_component_id", using: :btree
    t.index ["content_id"], name: "index_components_contents_on_content_id", using: :btree
  end

  create_table "contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "title"
    t.text     "content",    limit: 65535
    t.string   "locale"
    t.integer  "position",                 default: 0
    t.boolean  "is_index",                 default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "title"
    t.string   "forename"
    t.string   "surname"
    t.string   "v_title"
    t.string   "v_forename"
    t.string   "v_surname"
    t.string   "identification_credential"
    t.string   "mobile_phone"
    t.string   "email"
    t.string   "reason"
    t.text     "notes",                     limit: 65535
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "invoices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "code"
    t.boolean  "is_paid"
    t.integer  "total_cents"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["customer_id"], name: "index_invoices_on_customer_id", using: :btree
  end

  create_table "profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
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
    t.string   "role",          default: "Employee"
    t.boolean  "admin",         default: false
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", using: :btree
  end

  create_table "rooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "building"
    t.integer  "floor"
    t.integer  "number"
    t.text     "notes",       limit: 65535
    t.integer  "category_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["category_id"], name: "index_rooms_on_category_id", using: :btree
  end

  create_table "themes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "title"
    t.string   "navbar"
    t.string   "module"
    t.string   "footer"
    t.string   "content"
    t.boolean  "selected"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "email",                  limit: 191, default: "",    null: false
    t.string   "encrypted_password",                 default: "",    null: false
    t.string   "reset_password_token",   limit: 191
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token",     limit: 191
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                    default: 0,     null: false
    t.string   "unlock_token",           limit: 191
    t.datetime "locked_at"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "approved",                           default: false, null: false
    t.index ["approved"], name: "index_users_on_approved", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

end
