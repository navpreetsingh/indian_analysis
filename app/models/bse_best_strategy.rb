require 'csv'
class BseBestStrategy < ActiveRecord::Base
	belongs_to :bse_stock
	validates :date, uniqueness: { scope: :bse_stock_id}

	def self.auto 
		#BseBestStrategy.auto
		BseBestStrategy.strategy
		NseBestStrategy.strategy
		BseBestStrategy.csv_op
	end

	def self.strategy
		#data = CSV.read("/home/trantor/Downloads/bhav_copy/bse.csv")
		data = CSV.read("/home/navpreet/Downloads/bhav_copy/bse.csv")
		data.delete_at(0)		
		#data1 = CSV.read("/home/trantor/Downloads/bhav_copy/bse1.csv")
		data1 = CSV.read("/home/navpreet/Downloads/bhav_copy/bse1.csv")
		data1.delete_at(0)
		data1.each {|d| data << d}
		databs = BseBsStrategy.all
		rank_b = 1
		rank_s  =1
		data.each do |d|
			if d[12].nil? or d[12].split(":").first.to_i >= 9 
				nd = databs.where("bse_code = ?", d[4]).first
				unless nd.nil?
					c_open = d[20].to_f
					if c_open != 0 and c_open > nd.high											
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

	def self.csv_op
		datab_b_all = BseBestStrategy.where("bs_signal = 1").order("profit_percent desc").limit(10)
		datab_b = [["Name", "Last_close", "Expected Profit %", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close"]]
		datab_b_all.each do |d|
			datab_b << [d.stock_name, d.last_close, d.profit_percent, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close]
		end

		datab_s_all = BseBestStrategy.where("bs_signal = -1").order("profit_percent desc").limit(10)
		datab_s = [["Name", "Last_close", "Expected Profit %", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close"]]
		datab_s_all.each do |d|
			datab_s << [d.stock_name, d.last_close, d.profit_percent, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close]
		end

		datan_b_all = NseBestStrategy.where("bs_signal = 1").order("profit_percent desc").limit(10)
		datan_b = [["Name", "Last_close", "Expected Profit %", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close"]]
		datan_b_all.each do |d|
			datan_b << [d.stock_name, d.last_close, d.profit_percent, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close]
		end

		datan_s_all = NseBestStrategy.where("bs_signal = -1").order("profit_percent desc").limit(10)
		datan_s = [["Name", "Last_close", "Expected Profit %", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close"]]
		datan_s_all.each do |d|
			datan_s << [d.stock_name, d.last_close, d.profit_percent, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close]
		end

		CSV.open("error_files/best_strategy.csv", "wb") do |csv|
			csv << ["BSE"]
			csv << ["BUYERS"]
			datab_b.each do |d|
				csv << d
			end
			csv << [""]
			csv << [""]
			csv << [""]
			csv << ["SELLERS"]
			datab_s.each do |d|
				csv << d
			end

			csv << [""]
			csv << [""]
			csv << [""]
			csv << [""]
			csv << [""]
			csv << [""]

			csv << ["NSE"]
			csv << ["BUYERS"]
			datan_b.each do |d|
				csv << d
			end
			csv << [""]
			csv << [""]
			csv << [""]
			csv << ["SELLERS"]
			datan_s.each do |d|
				csv << d
			end
		end		
	end	
end
