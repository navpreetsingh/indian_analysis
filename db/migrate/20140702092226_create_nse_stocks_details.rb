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

      t.timestamps
    end
  end
end
