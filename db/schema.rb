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

ActiveRecord::Schema.define(version: 20181120020138) do

  create_table "emails", force: :cascade do |t|
    t.string   "status"
    t.integer  "user_id"
    t.integer  "shop_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "emails", ["shop_id"], name: "index_emails_on_shop_id"
  add_index "emails", ["user_id"], name: "index_emails_on_user_id"

  create_table "etemplates", force: :cascade do |t|
    t.string   "template_id"
    t.string   "template_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.float   "weight"
    t.float    "width"
    t.float    "length"
    t.float    "height"
    t.string   "image"
    t.boolean  "has_battery"
    t.float    "shipping_volume"
    t.integer  "order_quantity"
    t.text     "notes"
    t.integer  "email_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "products", ["email_id"], name: "index_products_on_email_id"

  create_table "quotes", force: :cascade do |t|
    t.float    "first_unit1"
    t.float    "first_unit2"
    t.float    "first_unit3"
    t.float    "first_unit4"
    t.float    "first_unit5"
    t.float    "additional1"
    t.float    "additional2"
    t.float    "additional3"
    t.float    "additional4"
    t.float    "additional5"
    t.float    "packaging_cost1"
    t.float    "packaging_cost2"
    t.float    "packaging_cost3"
    t.float    "packaging_cost4"
    t.float    "packaging_cost5"
    t.float    "storage_cost1"
    t.float    "storage_cost2"
    t.float    "storage_cost3"
    t.float    "storage_cost4"
    t.float    "storage_cost5"
    t.float    "international_fee1"
    t.float    "international_fee2"
    t.float    "international_fee3"
    t.float    "international_fee4"
    t.float    "international_fee5"
    t.string   "warehousing_option1"
    t.string   "warehousing_option2"
    t.string   "warehousing_option3"
    t.string   "warehousing_option4"
    t.string   "warehousing_option5"
    t.integer  "email_id"
    t.integer  "user_id"
    t.integer  "shop_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "quotes", ["email_id"], name: "index_quotes_on_email_id"
  add_index "quotes", ["shop_id"], name: "index_quotes_on_shop_id"
  add_index "quotes", ["user_id"], name: "index_quotes_on_user_id"

  create_table "shipping_options", force: :cascade do |t|
    t.float    "shipping_option1"
    t.float    "shipping_option2"
    t.float    "shipping_option3"
    t.float    "shipping_option4"
    t.float    "shipping_option5"
    t.integer  "quote_id"
    t.integer  "product_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "shipping_options", ["product_id"], name: "index_shipping_options_on_product_id"
  add_index "shipping_options", ["quote_id"], name: "index_shipping_options_on_quote_id"

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", null: false
    t.string   "shopify_token",  null: false
    t.string   "shop_name"
    t.string   "owner_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "template"
    t.string   "name"
    t.string   "company"
    t.string   "phone"
    t.string   "warehouse_location"
    t.boolean  "admin"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true

end
