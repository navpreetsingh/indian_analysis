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

ActiveRecord::Schema.define(version: 20140706113742) do

  create_table "bse1_trends", force: true do |t|
    t.integer  "bse_stock_id"
    t.integer  "d30_t"
    t.integer  "d_30_hi"
    t.integer  "d_30_li"
    t.integer  "d_30_chi"
    t.integer  "d_30_cli"
    t.integer  "d15_t"
    t.integer  "d_15_hi"
    t.integer  "d_15_li"
    t.integer  "d_15_chi"
    t.integer  "d_15_cli"
    t.integer  "d7_t"
    t.integer  "d_7_hi"
    t.integer  "d_7_li"
    t.integer  "d_7_chi"
    t.integer  "d_7_cli"
    t.integer  "d3_t"
    t.integer  "d_3_hi"
    t.integer  "d_3_li"
    t.integer  "d_3_chi"
    t.integer  "d_3_cli"
    t.float    "avg_high"
    t.float    "avg_low"
    t.float    "avg_close"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bse2_trends", force: true do |t|
    t.integer  "bse_stock_id"
    t.integer  "d30_t"
    t.integer  "d_30_hi"
    t.integer  "d_30_li"
    t.integer  "d_30_chi"
    t.integer  "d_30_cli"
    t.integer  "d15_t"
    t.integer  "d_15_hi"
    t.integer  "d_15_li"
    t.integer  "d_15_chi"
    t.integer  "d_15_cli"
    t.integer  "d7_t"
    t.integer  "d_7_hi"
    t.integer  "d_7_li"
    t.integer  "d_7_chi"
    t.integer  "d_7_cli"
    t.integer  "d3_t"
    t.integer  "d_3_hi"
    t.integer  "d_3_li"
    t.integer  "d_3_chi"
    t.integer  "d_3_cli"
    t.float    "avg_high"
    t.float    "avg_low"
    t.float    "avg_close"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bse3_trends", force: true do |t|
    t.integer  "bse_stock_id"
    t.integer  "d30_t"
    t.integer  "d_30_hi"
    t.integer  "d_30_li"
    t.integer  "d_30_chi"
    t.integer  "d_30_cli"
    t.integer  "d15_t"
    t.integer  "d_15_hi"
    t.integer  "d_15_li"
    t.integer  "d_15_chi"
    t.integer  "d_15_cli"
    t.integer  "d7_t"
    t.integer  "d_7_hi"
    t.integer  "d_7_li"
    t.integer  "d_7_chi"
    t.integer  "d_7_cli"
    t.integer  "d3_t"
    t.integer  "d_3_hi"
    t.integer  "d_3_li"
    t.integer  "d_3_chi"
    t.integer  "d_3_cli"
    t.float    "avg_high"
    t.float    "avg_low"
    t.float    "avg_close"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bse4_trends", force: true do |t|
    t.integer  "bse_stock_id"
    t.integer  "d30_t"
    t.integer  "d_30_hi"
    t.integer  "d_30_li"
    t.integer  "d_30_chi"
    t.integer  "d_30_cli"
    t.integer  "d15_t"
    t.integer  "d_15_hi"
    t.integer  "d_15_li"
    t.integer  "d_15_chi"
    t.integer  "d_15_cli"
    t.integer  "d7_t"
    t.integer  "d_7_hi"
    t.integer  "d_7_li"
    t.integer  "d_7_chi"
    t.integer  "d_7_cli"
    t.integer  "d3_t"
    t.integer  "d_3_hi"
    t.integer  "d_3_li"
    t.integer  "d_3_chi"
    t.integer  "d_3_cli"
    t.float    "avg_high"
    t.float    "avg_low"
    t.float    "avg_close"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer "bs_signal",      null: false
    t.float   "oh_diff",        null: false
    t.float   "ol_diff",        null: false
    t.float   "oc_diff",        null: false
    t.float   "ch_diff",        null: false
    t.float   "cl_diff",        null: false
    t.float   "cc_diff",        null: false
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
    t.integer "bs_signal",    null: false
    t.float   "oh_diff",      null: false
    t.float   "ol_diff",      null: false
    t.float   "oc_diff",      null: false
    t.float   "ch_diff",      null: false
    t.float   "cl_diff",      null: false
    t.float   "cc_diff",      null: false
  end

end
