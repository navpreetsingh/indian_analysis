require 'csv'
class BseBestStrategy < ActiveRecord::Base
	belongs_to :bse_stock
	validates :stock_name, uniqueness: true
	def self.strategy
		data = CSV.read("/home/trantor/Downloads/bhav_copy/bse_fresh.csv")
		data.delete_at(0)
		databs = BseBsStrategy.all
		rank_b = 1
		rank_s  =1
		data.each do |d|
			if d[12].nil? or d[12].split(":").first.to_i >= 9 
				nd = databs.where("bse_code = ?", d[4]).first
				unless nd.nil?
					c_open = d[17].to_f
					if c_open != 0 and c_open > nd.high
						#debugger					
						BseBestStrategy.create(:stock_name => nd.stock_name, 
							:bse_stock_id => nd.bse_stock_id, :bse_code => nd.bse_code, 
							:date => nd.date, :vol_category => nd.vol_category, 
							:profit_percent => ((c_open - nd.low) / c_open) * 100,
							:last_close => nd.last_close, :bs_signal => -1, 
							:open => nd.open, :current_open => c_open, :high => nd.high, 
							:low => nd.low, :close => nd.close,	
							:target_1 => nd.open, :stop_loss_1 => c_open * 1.01,
							:target_2 => nd.low, :stop_loss_2 => c_open.to_i,
							:target_3 => nd.low * 0.98, :stop_loss_3 => nd.open,
							:rank => rank_s, :strategy => 5)
						rank_s += 1
					elsif c_open != 0 and c_open < nd.low		
					#debugger			
						BseBestStrategy.create(:stock_name => nd.stock_name, 
							:bse_stock_id => nd.bse_stock_id, :bse_code => nd.bse_code, 
							:date => nd.date, :vol_category => nd.vol_category, 
							:profit_percent => ((nd.high - c_open ) / c_open) * 100,
							:last_close => nd.last_close, :bs_signal => 1, 
							:open => nd.open, :current_open => c_open, :high => nd.high, 
							:low => nd.low, :close => nd.close,	
							:target_1 => nd.open, :stop_loss_1 => c_open * 0.99,
							:target_2 => nd.high, :stop_loss_2 => c_open.to_i,
							:target_3 => nd.high * 1.02, :stop_loss_3 => nd.open,
							:rank => rank_b, :strategy => 5)
						rank_b += 1
					end
				end
			end
		end
	end
end
