# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160127185541) do

  create_table "addresses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "city_id"
    t.string  "street_and_house"
    t.string  "door_number"
    t.string  "coordinate"
    t.integer "zip_code"
    t.boolean "active",           default: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "image"
  end

  create_table "categories_products_joins", force: :cascade do |t|
    t.integer "product_id",  null: false
    t.integer "category_id", null: false
  end

  add_index "categories_products_joins", ["category_id"], name: "index_categories_products_joins_on_category_id"
  add_index "categories_products_joins", ["product_id"], name: "index_categories_products_joins_on_product_id"

  create_table "cities", force: :cascade do |t|
    t.string  "name"
    t.string  "polygon"
    t.boolean "active",  default: true
  end

  create_table "coupons", force: :cascade do |t|
    t.string  "name"
    t.string  "code"
    t.integer "discount"
  end

  create_table "delivery_boys", force: :cascade do |t|
    t.integer "user_id"
    t.integer "current_order_id"
    t.string  "status"
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
    t.integer  "address_id"
    t.integer  "user_id"
    t.string   "status"
    t.decimal  "pure_product_price", precision: 8, scale: 2
    t.decimal  "tax",                precision: 8, scale: 2
    t.decimal  "delivery_charge",    precision: 8, scale: 2
    t.decimal  "total_price",        precision: 8, scale: 2
    t.decimal  "coupon_discount",    precision: 8, scale: 2
    t.datetime "created_at",                                                  null: false
    t.datetime "confirmed_at"
    t.datetime "approved_at"
    t.datetime "dispacthed_at"
    t.datetime "delivered_at"
    t.datetime "canceled_at"
    t.date     "wanted_date"
    t.string   "wanted_time"
    t.integer  "delivery_boy_id"
    t.string   "payment_type",                               default: "cash"
    t.boolean  "is_paid",                                    default: false
    t.string   "coupon_code"
    t.text     "comment"
    t.text     "feedback"
    t.text     "admin_comment"
    t.string   "source_type"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.decimal  "price",           precision: 8, scale: 2
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "inventory_count"
    t.integer  "city_id"
    t.string   "description"
    t.string   "image"
  end

  add_index "products", ["city_id"], name: "index_products_on_city_id"

  create_table "settings", force: :cascade do |t|
    t.decimal "tax_in_percentage",       precision: 4, scale: 2
    t.decimal "free_delivery_order_sum", precision: 8, scale: 2
    t.decimal "default_delivery_cost",   precision: 8, scale: 2
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "provider",                  default: "email", null: false
    t.string   "uid",                       default: "",      null: false
    t.string   "encrypted_password",        default: "",      null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "tokens"
    t.string   "phone"
    t.string   "verification_code"
    t.boolean  "is_verified",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "how_did_you_hear_about_us"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true

end
