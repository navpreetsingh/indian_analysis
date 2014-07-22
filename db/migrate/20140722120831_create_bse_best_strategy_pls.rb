class CreateBseBestStrategyPls < ActiveRecord::Migration
  def change
    create_table :bse_best_strategy_pls do |t|
    	t.string :stock_name
    	t.integer :bse_stock_id
    	t.integer :bse_code
    	t.date :date
    	t.date :exec_date
    	t.integer :bs_signal
    	t.integer :vol_category
        t.float :exp_profit_percent
        t.float :profit_loss
    	t.float :open
        t.float :high
        t.float :low
        t.float :close
    	t.float :target_1
    	t.float :stop_loss_1
    	t.float :target_2
    	t.float :stop_loss_2
    	t.float :target_3
    	t.float :stop_loss_3    	    	
     	t.timestamps
    end
  end
end
