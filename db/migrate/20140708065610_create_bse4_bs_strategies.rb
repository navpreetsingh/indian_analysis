class CreateBse4BsStrategies < ActiveRecord::Migration
  def change
    create_table :bse4_bs_strategies do |t|
    	t.string :stock_name
    	t.integer :bse_stock_id
    	t.date :date
    	t.date :executed_date
    	t.float :last_close
    	t.integer :bs_signal
    	t.float :open
    	t.float :target_1
    	t.float :stop_loss_1
    	t.float :target_2
    	t.float :stop_loss_2
    	t.float :target_3
    	t.float :stop_loss_3
    	t.float :profit_loss
    	t.integer :rank
    	t.integer :strategy
    	t.timestamps
    end
  end
end
