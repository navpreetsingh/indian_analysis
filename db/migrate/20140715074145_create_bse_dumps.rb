class CreateBseDumps < ActiveRecord::Migration
  def change
    create_table :bse_dumps do |t|
    	t.integer :bse_stock_id
      t.date :date
      t.float :open
      t.float :high
      t.float :low
      t.float :close
      t.integer :volume
      t.integer :no_of_trades
      t.integer :total_turnover      
    end
  end
end
