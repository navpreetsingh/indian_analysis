class CreateBseStocksDetails < ActiveRecord::Migration
  def change
    create_table :bse_stocks_details do |t|
      t.integer :bse_stock_id
      t.date :date
      t.float :open
      t.float :high
      t.float :low
      t.float :close
      t.integer :volume
      t.integer :no_of_trades
      t.integer :total_turnover

      t.timestamps
    end
  end
end
