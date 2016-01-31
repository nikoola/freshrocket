class SetupSchema < ActiveRecord::Migration


  create_table "cities", force: :cascade do |t|
    t.string "name"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "amount"
    t.decimal "fixed_price", precision: 8, scale: 2
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id"
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status"
    t.decimal  "fixed_price", precision: 8, scale: 2
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "comment"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.decimal  "price",              precision: 8, scale: 2
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "inventory_count"
    t.integer  "city_id"
  end

  add_index "products", ["city_id"], name: "index_products_on_city_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "phone"
    t.string   "role"
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true



end
