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

ActiveRecord::Schema.define(version: 20150925124659) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cars", force: :cascade do |t|
    t.string   "car_name"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "car_image_file_name"
    t.string   "car_image_content_type"
    t.integer  "car_image_file_size"
    t.datetime "car_image_updated_at"
    t.string   "type"
    t.string   "plate"
  end

  add_index "cars", ["user_id"], name: "index_cars_on_user_id", using: :btree

  create_table "promotion_codes", force: :cascade do |t|
    t.string   "email"
    t.integer  "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password"
    t.string   "phonenumber"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "logged_in"
    t.string   "loc_latitude"
    t.string   "loc_longitude"
    t.boolean  "isWasher"
    t.string   "credit_id"
    t.string   "credit_exp_month"
    t.string   "credit_exp_year"
    t.string   "paypal_email"
    t.string   "apple_pay_merchant_identify"
    t.string   "apple_pay_support_network"
    t.string   "apple_pay_merchant_capabilities"
    t.string   "apple_pay_country_code"
    t.string   "apple_pay_currency_code"
    t.string   "apple_pay_summary_items"
    t.string   "user_avatar_file_name"
    t.string   "user_avatar_content_type"
    t.integer  "user_avatar_file_size"
    t.datetime "user_avatar_updated_at"
  end

  add_foreign_key "cars", "users"
end
