class CreateNseBsStrategies < ActiveRecord::Migration
  def change
    create_table :nse_bs_strategies do |t|
    	t.string :stock_name
    	t.integer :nse_stock_id
    	t.date :date
    	t.float :last_close
    	t.integer :bs_signal
    	t.integer :vol_category
        t.float :profit_percent
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
    	t.integer :rank
    	t.integer :strategy
     	t.timestamps
    end
  end
end
