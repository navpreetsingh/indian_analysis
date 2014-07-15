class CreateNseStocksDetails < ActiveRecord::Migration
  def change
    create_table :nse_stocks_details do |t|
      t.integer :nse_stock_id
      t.date :date
      t.float :open
      t.float :high
      t.float :low
      t.float :close
      t.integer :volume
      t.float :turnover
      t.integer :bs_signal
      t.float :oh_diff
      t.float :ol_diff
      t.float :oc_diff
      t.float :lco_diff
      t.float :ch_diff
      t.float :cl_diff
      t.float :cc_diff     
    end
  end
end
