require 'csv'
class NseBestStrategy < ActiveRecord::Base
	belongs_to :nse_stock
	validates :date, uniqueness: { scope: :nse_stock_id}

	def self.strategy
		data = CSV.read("/home/trantor/Downloads/bhav_copy/nse.csv")
		#data = CSV.read("/home/navpreet/Downloads/bhav_copy/nse.csv")
		data.delete_at(0)		
		datans = NseBsStrategy.all
		rank_b = 1
		rank_s  =1
		data.each do |d|
			if d[12].nil? or d[12].split(":").first.to_i >= 9 
				nd = datans.where("stock_name = ?", d[5]).first
				unless nd.nil?
					c_open = d[20].to_f
					if c_open != 0 and c_open > nd.high											
						NseBestStrategy.create(:stock_name => nd.stock_name, 
							:nse_stock_id => nd.nse_stock_id,
							:date => nd.date, :vol_category => nd.vol_category, 
							:profit_percent => ((c_open - nd.low) / c_open) * 100,
							:last_close => nd.last_close, :bs_signal => -1, 
							:open => nd.open, :current_open => c_open, :high => nd.high, 
							:low => nd.low, :close => nd.close,	
							:target_1 => nd.open, :stop_loss_1 => c_open * 1.01,
							:target_2 => nd.low, :stop_loss_2 => c_open.to_i,
							:target_3 => nd.low * 0.98, :stop_loss_3 => nd.open,
							:rank => rank_s, :strategy => nd.strategy,
							:predicted_signal => nd.bs_signal)
						rank_s += 1
					elsif c_open != 0 and c_open < nd.low		
					#debugger			
						NseBestStrategy.create(:stock_name => nd.stock_name, 
							:nse_stock_id => nd.nse_stock_id,
							:date => nd.date, :vol_category => nd.vol_category, 
							:profit_percent => ((nd.high - c_open ) / c_open) * 100,
							:last_close => nd.last_close, :bs_signal => 1, 
							:open => nd.open, :current_open => c_open, :high => nd.high, 
							:low => nd.low, :close => nd.close,	
							:target_1 => nd.open, :stop_loss_1 => c_open * 0.99,
							:target_2 => nd.high, :stop_loss_2 => c_open.to_i,
							:target_3 => nd.high * 1.02, :stop_loss_3 => nd.open,
							:rank => rank_b, :strategy => nd.strategy,
							:predicted_signal => nd.bs_signal)
						rank_b += 1
					end
				end
			end
		end
	end
end
