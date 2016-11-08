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

ActiveRecord::Schema.define(version: 20161108063938) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "investors", force: :cascade do |t|
    t.string   "name"
    t.decimal  "tys_2015_income"
    t.decimal  "tys_2016_income"
    t.decimal  "tracys_income"
    t.decimal  "existing_home_value"
    t.decimal  "existing_debt"
    t.decimal  "checking_savings"
    t.decimal  "retirement_savings"
    t.decimal  "maxium_cash_out_loan_amount"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.decimal  "my_rental_payment"
  end

  create_table "properties", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "loan_type"
    t.decimal  "purchase_price"
    t.decimal  "down_payment_pct"
    t.decimal  "monthly_gross_rental_income"
    t.integer  "stated_residence"
    t.integer  "actual_residence"
    t.integer  "investor_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "sell_existing"
    t.decimal  "omi_unit_rent"
    t.text     "notes"
    t.integer  "number_of_units"
    t.string   "link"
  end

  add_index "properties", ["investor_id"], name: "index_properties_on_investor_id", using: :btree

  add_foreign_key "properties", "investors"
end
