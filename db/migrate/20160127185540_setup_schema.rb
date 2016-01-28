class SetupSchema < ActiveRecord::Migration

  create_table "cities", force: :cascade do |t|
    t.string "name"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "amount"
    t.decimal "fixed_price"
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id"
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id"


  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status"
    t.decimal  "fixed_price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.decimal  "price"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "inventory_count"
    t.integer  "city_id"
  end

  add_index "products", ["city_id"], name: "index_products_on_city_id"

end
