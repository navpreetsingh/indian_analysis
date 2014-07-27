class CreateStrategyAnalyses < ActiveRecord::Migration
  def change
    create_table :strategy_analyses do |t|
    	t.integer :strategy
        t.date :date
    	t.integer :bs_signal
    	t.integer :total_shares
    	t.float :profit_loss
    	t.integer :profit_shares
    	t.float :profit
    	t.integer :loss_shares
    	t.float :loss
    	t.integer :investment
    	t.float :ror
      	t.timestamps
    end
  end
end
