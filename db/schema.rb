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

ActiveRecord::Schema.define(version: 20140803045446) do

  create_table "bse4_bs_strategies", force: true do |t|
    t.string   "stock_name",    null: false
    t.integer  "bse_stock_id"
    t.date     "date"
    t.date     "executed_date"
    t.float    "last_close"
    t.integer  "bs_signal"
    t.float    "open"
    t.float    "high",          null: false
    t.float    "low",           null: false
    t.float    "close",         null: false
    t.float    "target_1"
    t.float    "stop_loss_1"
    t.float    "target_2"
    t.float    "stop_loss_2"
    t.float    "target_3"
    t.float    "stop_loss_3"
    t.float    "profit_loss"
    t.integer  "rank"
    t.integer  "strategy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bse4p_trends", force: true do |t|
    t.integer  "bse_stock_id"
    t.string   "stock_name",   null: false
    t.date     "date"
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
    t.integer  "bs_signal",    null: false
    t.float    "last_close",   null: false
    t.float    "avg_open"
    t.float    "avg_high"
    t.float    "avg_low"
    t.float    "avg_close"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bse_best_strategies", force: true do |t|
    t.string   "stock_name"
    t.integer  "bse_stock_id"
    t.integer  "bse_code"
    t.date     "date"
    t.float    "last_close"
    t.integer  "bs_signal"
    t.integer  "vol_category"
    t.float    "profit_percent"
    t.float    "open"
    t.float    "current_open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.float    "target_1"
    t.float    "stop_loss_1"
    t.float    "target_2"
    t.float    "stop_loss_2"
    t.float    "target_3"
    t.float    "stop_loss_3"
    t.integer  "rank"
    t.integer  "strategy"
    t.integer  "predicted_signal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bse_best_strategy_pls", force: true do |t|
    t.string   "stock_name"
    t.integer  "bse_stock_id"
    t.integer  "bse_code"
    t.date     "date"
    t.date     "exec_date"
    t.integer  "bs_signal"
    t.integer  "vol_category"
    t.float    "exp_profit_percent"
    t.float    "profit_loss"
    t.float    "open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.float    "target_1"
    t.float    "stop_loss_1"
    t.float    "target_2"
    t.float    "stop_loss_2"
    t.float    "target_3"
    t.float    "stop_loss_3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bse_bs_strategies", force: true do |t|
    t.string   "stock_name"
    t.integer  "bse_stock_id"
    t.integer  "bse_code",       null: false
    t.date     "date"
    t.float    "last_close"
    t.integer  "bs_signal"
    t.integer  "vol_category"
    t.float    "profit_percent"
    t.float    "open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.float    "target_1"
    t.float    "stop_loss_1"
    t.float    "target_2"
    t.float    "stop_loss_2"
    t.float    "target_3"
    t.float    "stop_loss_3"
    t.integer  "rank"
    t.integer  "strategy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bse_dumps", force: true do |t|
    t.integer "bse_stock_id"
    t.date    "date"
    t.float   "open"
    t.float   "high"
    t.float   "low"
    t.float   "close"
    t.integer "volume"
    t.integer "no_of_trades"
    t.integer "total_turnover", limit: 8
  end

  create_table "bse_indices", force: true do |t|
    t.string "indices_name"
  end

  create_table "bse_indices_dumps", force: true do |t|
    t.integer "bse_indices_id"
    t.date    "date"
    t.float   "open"
    t.float   "high"
    t.float   "low"
    t.float   "close"
  end

  create_table "bse_stocks", force: true do |t|
    t.string  "stock_name"
    t.integer "vol_category"
    t.integer "price_category"
    t.integer "bse_code",       default: 0, null: false
    t.integer "useless_stock"
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
    t.integer "total_turnover", limit: 8
    t.integer "bs_signal"
    t.float   "oh_diff"
    t.float   "ol_diff"
    t.float   "oc_diff"
    t.float   "lco_diff"
    t.float   "ch_diff"
    t.float   "cl_diff"
    t.float   "cc_diff"
  end

  create_table "bse_trends", force: true do |t|
    t.integer  "bse_stock_id"
    t.string   "stock_name"
    t.integer  "bse_code",     null: false
    t.integer  "vol_category"
    t.date     "date"
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
    t.integer  "bs_signal"
    t.float    "last_close"
    t.float    "avg_open"
    t.float    "avg_high"
    t.float    "avg_low"
    t.float    "avg_close"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "examples", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nse_best_strategies", force: true do |t|
    t.string   "stock_name"
    t.integer  "nse_stock_id"
    t.date     "date"
    t.float    "last_close"
    t.integer  "bs_signal"
    t.integer  "vol_category"
    t.float    "profit_percent"
    t.float    "open"
    t.float    "current_open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.float    "target_1"
    t.float    "stop_loss_1"
    t.float    "target_2"
    t.float    "stop_loss_2"
    t.float    "target_3"
    t.float    "stop_loss_3"
    t.integer  "rank"
    t.integer  "strategy"
    t.integer  "predicted_signal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nse_bs_strategies", force: true do |t|
    t.string   "stock_name"
    t.integer  "nse_stock_id"
    t.date     "date"
    t.float    "last_close"
    t.integer  "bs_signal"
    t.integer  "vol_category"
    t.float    "profit_percent"
    t.float    "open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.float    "target_1"
    t.float    "stop_loss_1"
    t.float    "target_2"
    t.float    "stop_loss_2"
    t.float    "target_3"
    t.float    "stop_loss_3"
    t.integer  "rank"
    t.integer  "strategy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nse_dumps", force: true do |t|
    t.integer "nse_stock_id"
    t.date    "date"
    t.float   "open"
    t.float   "high"
    t.float   "low"
    t.float   "close"
    t.integer "volume"
    t.float   "turnover"
  end

  create_table "nse_indices", force: true do |t|
    t.string "indices_name"
  end

  create_table "nse_indices_dumps", force: true do |t|
    t.integer "nse_indices_id"
    t.date    "date"
    t.float   "open"
    t.float   "high"
    t.float   "low"
    t.float   "close"
    t.integer "volume",         limit: 8
  end

  create_table "nse_month_details", force: true do |t|
    t.integer "nse_stock_id"
    t.string  "date"
    t.float   "open"
    t.float   "high"
    t.float   "low"
    t.float   "close"
    t.integer "volume"
    t.integer "bs_signal"
    t.float   "oh_diff"
    t.float   "ol_diff"
    t.float   "oc_diff"
    t.date    "date1"
  end

  create_table "nse_stocks", force: true do |t|
    t.string  "stock_name"
    t.integer "vol_category"
    t.integer "price_category"
    t.integer "useless_stock"
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
    t.integer "bs_signal"
    t.float   "oh_diff"
    t.float   "ol_diff"
    t.float   "oc_diff"
    t.float   "lco_diff"
    t.float   "ch_diff"
    t.float   "cl_diff"
    t.float   "cc_diff"
  end

  create_table "nse_trends", force: true do |t|
    t.integer  "nse_stock_id"
    t.string   "stock_name"
    t.integer  "vol_category"
    t.date     "date"
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
    t.integer  "bs_signal"
    t.float    "last_close"
    t.float    "avg_open"
    t.float    "avg_high"
    t.float    "avg_low"
    t.float    "avg_close"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nse_week_details", force: true do |t|
    t.integer "nse_stock_id"
    t.date    "date"
    t.float   "open"
    t.float   "high"
    t.float   "low"
    t.float   "close"
    t.integer "volume"
    t.integer "bs_signal"
    t.float   "oh_diff"
    t.float   "ol_diff"
    t.float   "oc_diff"
  end

  create_table "nse_year_details", force: true do |t|
    t.integer "nse_stock_id"
    t.string  "year"
    t.float   "open"
    t.float   "high"
    t.float   "low"
    t.float   "close"
    t.integer "volume"
    t.integer "bs_signal"
    t.float   "oh_diff"
    t.float   "ol_diff"
    t.float   "oc_diff"
    t.date    "date1"
  end

  create_table "strategy_analyses", force: true do |t|
    t.integer  "strategy"
    t.date     "date"
    t.integer  "bs_signal"
    t.integer  "total_shares"
    t.float    "profit_loss"
    t.integer  "profit_shares"
    t.float    "profit"
    t.integer  "loss_shares"
    t.float    "loss"
    t.integer  "investment"
    t.float    "ror"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
