class BseBestStrategyPl < ActiveRecord::Base
belongs_to :bse_stock
	validates :date, uniqueness: { scope: :bse_stock_id}

	def self.strategy
		date = BseBestStrategy.uniq.pluck(:date).first

		#For best buyers
			data = BseBestStrategy.where("date = ? and bs_signal = 1", date).order("profit_percent desc")
			
			data.each do |d|
				new_d =  BseStocksDetail.where("bse_stock_id = ? AND date > ?", d.bse_stock_id, d.date).first
				unless new_d.nil?
					shares_bought = (10000 / new_d.open).to_i
					pl = (new_d.close - new_d.open) * shares_bought					
					
					BseBestStrategyPl.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
						:bse_code => d.bse_code, :date => d.date, :exec_date => new_d.date, 
						:bs_signal => 1, :vol_category => d.vol_category, 
						:exp_profit_percent => d.profit_percent,
						:profit_loss => pl,
						:open => new_d.open, :high => new_d.high, 
						:low => new_d.low, :close => new_d.close,
						:target_1 => d.target_1, :stop_loss_1 => d.stop_loss_1,
						:target_2 => d.target_2, :stop_loss_2 => d.stop_loss_2,
						:target_3 => d.target_3, :stop_loss_3 => d.stop_loss_3)						
				end				
			end		

		#For best sellers
			data = BseBestStrategy.where("date = ? and bs_signal = -1", date).order("profit_percent desc")
			data.each do |d|	
				new_d =  BseStocksDetail.where("bse_stock_id = ? AND date > ?", d.bse_stock_id, d.date).first
				unless new_d.nil?
					shares_bought = (10000 / new_d.open).to_i
					pl = (new_d.open - new_d.close) * shares_bought
					BseBestStrategyPl.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
						:bse_code => d.bse_code, :date => d.date, :exec_date => new_d.date, 
						:bs_signal => -1, :vol_category => d.vol_category, 
						:exp_profit_percent => d.profit_percent,
						:profit_loss => pl,
						:open => new_d.open, :high => new_d.high, 
						:low => new_d.low, :close => new_d.close,
						:target_1 => d.target_1, :stop_loss_1 => d.stop_loss_1,
						:target_2 => d.target_2, :stop_loss_2 => d.stop_loss_2,
						:target_3 => d.target_3, :stop_loss_3 => d.stop_loss_3)					
				end						
			end
	end	
end