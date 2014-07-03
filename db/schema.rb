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

ActiveRecord::Schema.define(version: 20140702092226) do

  create_table "BSE_high_volume_stocks", force: true do |t|
    t.integer "BSE_stock_id", null: false
  end

  create_table "BSE_stocks", force: true do |t|
    t.string  "stock_name",      null: false
    t.string  "stock_full_name", null: false
    t.integer "vol_category",    null: false
  end

  create_table "BSE_stocks_details", force: true do |t|
    t.integer "BSE_stock_id",   null: false
    t.date    "date",           null: false
    t.float   "open",           null: false
    t.float   "high",           null: false
    t.float   "low",            null: false
    t.float   "close",          null: false
    t.integer "volume",         null: false
    t.integer "no_of_trades",   null: false
    t.integer "total_turnover", null: false
  end

  create_table "NSE_high_volume_stocks", force: true do |t|
    t.integer "NSE_stock_id", null: false
  end

  create_table "NSE_stocks", force: true do |t|
    t.string  "stock_name",   null: false
    t.integer "vol_category", null: false
  end

  create_table "NSE_stocks_details", force: true do |t|
    t.integer "NSE_stock_id", null: false
    t.date    "date",         null: false
    t.float   "open",         null: false
    t.float   "high",         null: false
    t.float   "low",          null: false
    t.float   "close",        null: false
    t.integer "volume",       null: false
    t.float   "turnover",     null: false
  end

  create_table "bse_stocks", force: true do |t|
    t.string  "stock_name"
    t.string  "stock_full_name"
    t.integer "vol_category"
  end

  create_table "bse_stocks_details", force: true do |t|
    t.integer "bse_stock_id"
    t.date    "date"
    t.float   "open"
    t.float   "high"
    t.float   "low"
    t.float   "close"
    t.integer "volume"
    t.integer "no_of_trades"
    t.integer "total_turnover"
  end

  create_table "nse_stocks", force: true do |t|
    t.string  "stock_name"
    t.integer "vol_category"
  end

  create_table "nse_stocks_details", force: true do |t|
    t.integer "nse_stock_id"
    t.date    "date"
    t.float   "open"
    t.float   "high"
    t.float   "low"
    t.float   "close"
    t.integer "volume"
    t.float   "turnover"
  end

end
