require 'csv'

class BseBsStrategy < ActiveRecord::Base
belongs_to :bse_stock
validates :stock_name, uniqueness: true

	def self.strategy
		#For best BUYERS
		data = BseTrend.order("avg_high desc")
		rank = 1

		data.each do |d|
			open = (d.last_close * ( 1 + (d.avg_open / 100)))
			if d.avg_high > (-1 * d.avg_low)
				if d.avg_high > 4 
					if d.avg_low > 0
						target1 = open * 1.02
						stop_loss1 = open
						target2 = open * 1.035
						stop_loss2 = open * 1.01
						target3 = open * 1.05
						stop_loss3 = open * 1.03
						stp = 1
					elsif d.avg_low < 0 and d.avg_low > -1
						target1 = open * 1.02
						stop_loss1 = open * (1 + ((d.avg_low * 1.25)/100))
						target2 = open * 1.035
						stop_loss2 = open 
						target3 = open * 1.05
						stop_loss3 = open * 1.025
						stp = 3
					else
						target1 = open * 1.02
						stop_loss1 = open * (1 + ((d.avg_low)/100))
						target2 = open * 1.035
						stop_loss2 = open 
						target3 = open * 1.05
						stop_loss3 = open * 1.02
						stp = 5 if d.avg_low > -2
						stp = 7 if d.avg_low < -2
					end
				else
					if d.avg_low > 0
						d.avg_low = 1 if d.avg_low > 1
						target1 = open * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = open
						target2 = open * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = open * (1 + ((d.avg_low)/100))
						target3 = open * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = open * (1 + ((d.avg_low * 1.25)/100))
						stp = 2
					elsif d.avg_low < 0 and d.avg_low > -1
						target1 = open * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = open * (1 + ((d.avg_low * 1.25)/100))
						target2 = open * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = open  
						target3 = open * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = open * (1 - ((d.avg_low * 0.2)/100))
						stp = 4
					else
						target1 = open * (1 + ((d.avg_high * 0.25)/100))
						stop_loss1 = open * (1 + ((d.avg_low)/100))
						target2 = open * (1 + ((d.avg_high * 0.4)/100))
						stop_loss2 = open * (1 + ((d.avg_low * 0.25)/100))
						target3 = open * (1 + ((d.avg_high * 0.5)/100))
						stop_loss3 = open * (1 - ((d.avg_low * 0.25)/100))
						stp = 6 if d.avg_low > -2
						stp = 8 if d.avg_low <= -2
					end
				end
				str = 60
				str = 10 if d.d3_t == 3
				str = 20 if d.d3_t == 1 and d.bs_signal == 1
				str = 30 if d.d3_t == -1 and d.bs_signal == 1
				str = 40 if d.d3_t == 1 and d.bs_signal == -1
				str = 50 if d.d3_t == -1 and d.bs_signal == -1


				st = 500 + str + stp
				st = 100 + str + stp if d.d30_t >= 0 and d.d15_t > 0 and d.d7_t > 0
				st = 200 + str + stp if d.d30_t < 0 and d.d15_t > 0 and d.d7_t > 0
				st = 300 + str + stp if d.d30_t < 0 and d.d15_t < 0 and d.d7_t > 0
				st = 400 + str + stp if d.d30_t < 0 and d.d15_t < 0 and d.d7_t < 0 and d.d3_t > 0
				
				BseBsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
					:bse_code => d.bse_code, :date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
					:bs_signal => 1, :profit_percent => d.avg_high,
					:open => open, 
					:high => (open * (1 + (d.avg_high / 100))), 
					:low => (open * (1 + (d.avg_low / 100))),
					:close => (open * (1 + (d.avg_close / 100))),
					:target_1 => target1, :stop_loss_1 => stop_loss1,
					:target_2 => target2, :stop_loss_2 => stop_loss2,
					:target_3 => target3, :stop_loss_3 => stop_loss3,
					:rank => rank, :strategy => st)
				rank += 1				
			end
		end	

		#For best sellers
		data = BseTrend.order("avg_low asc")
		rank = 1
		data.each do |d|	
			open = (d.last_close * ( 1 + (d.avg_open / 100)))
			if (-1 * d.avg_low) > d.avg_high
				if d.avg_low < -4
					if d.avg_high < 0
						d.avg_high = -1 if d.avg_high < -1
						target1 = open * 0.98
						stop_loss1 = open
						target2 = open * 0.965
						stop_loss2 = open * 0.99
						target3 = open * 0.95
						stop_loss3 = open * 0.97
						stp = 1
					elsif d.avg_high > 0 and d.avg_low < 1
						target1 = open * 0.98
						stop_loss1 = open * (1 + ((d.avg_high * 1.25)/100))
						target2 = open * 0.965
						stop_loss2 = open 
						target3 = open * 0.95
						stop_loss3 = open * 0.975
						stp = 3
					else
						target1 = open * 0.98
						stop_loss1 = open * (1 + ((d.avg_high)/100))
						target2 = open * 0.965
						stop_loss2 = open 
						target3 = open * 0.95
						stop_loss3 = open * 0.98
						stp = 5
					end
				else
					if d.avg_high < 0
						d.avg_high = -1 if d.avg_high < -1
						target1 = open * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = open
						target2 = open * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = open * (1 - ((d.avg_high)/100))
						target3 = open * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = open * (1 - ((d.avg_high * 1.25)/100))
						stp = 2
					elsif d.avg_high > 0 and d.avg_high < 1
						target1 = open * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = open * (1 + ((d.avg_high * 1.25)/100))
						target2 = open * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = open  
						target3 = open * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = open * (1 - ((d.avg_high * 0.2)/100))
						stp = 4
					else
						target1 = open * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = open * (1 + ((d.avg_high)/100))
						target2 = open * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = open * (1 + ((d.avg_high * 0.25)/100))
						target3 = open * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = open * (1 - ((d.avg_high * 0.25)/100))
						stp = 6
					end
				end
				
				str = 60
				str = 10 if d.d3_t == -3
				str = 20 if d.d3_t == -1 and d.bs_signal == -1
				str = 30 if d.d3_t == 1 and d.bs_signal == -1
				str = 40 if d.d3_t == -1 and d.bs_signal == 1
				str = 50 if d.d3_t == 1 and d.bs_signal == 1

				st = 500 + str + stp
				st = 100 + str + stp if d.d30_t <= 0 and d.d15_t < 0 and d.d7_t < 0
				st = 200 + str + stp if d.d30_t > 0 and d.d15_t < 0 and d.d7_t < 0
				st = 300 + str + stp if d.d30_t > 0 and d.d15_t > 0 and d.d7_t < 0
				st = 400 + str + stp if d.d30_t > 0 and d.d15_t > 0 and d.d7_t > 0 and d.d3_t < 0

				BseBsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
					:bse_code => d.bse_code, :date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
					:bs_signal => -1, :profit_percent => d.avg_low,
					:open => (d.last_close * ( 1 + (d.avg_open / 100))), 
					:high => (d.last_close * (1 + (d.avg_high / 100))), 
					:low => (d.last_close * (1 + (d.avg_low / 100))),
					:close => (d.last_close * (1 + (d.avg_close / 100))),
					:target_1 => target1, :stop_loss_1 => stop_loss1,
					:target_2 => target2, :stop_loss_2 => stop_loss2,
					:target_3 => target3, :stop_loss_3 => stop_loss3,
					:rank => rank, :strategy => st)
				rank += 1
			end
		end		
	end

	def self.csv_op
		data = [111, 113, 115, 117, 112, 
				121, 123, 125, 127, 122,
				131, 133, 135, 137, 132,
				141, 143, 145, 147, 142,
				151, 153, 155, 157, 152,
				211, 213, 215, 217, 212,
				221, 223, 225, 227, 222, 
				231, 233, 235, 237, 232, 
				241, 243, 245, 247, 242,
				251, 253, 255, 257, 252,
				311, 313, 315, 317, 312, 
				321, 323, 325, 327, 322, 
				331, 333, 335, 337, 332, 
				341, 343, 345, 347, 342, 
				351, 353, 355, 357, 352,
				411, 413, 415, 417, 412, 
				421, 423, 425, 427, 422]

		datab_b = [["Name", "BSE Code" , "Profit Percent", "Last_close", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close", "Strategy"]]
		datab_b_all = BseBsStrategy.where("bs_signal = 1").order("profit_percent desc").limit(10)
		datab_b_all.each do |d|
			if data.include?(d.strategy)
				if d.strategy % 10 == 7 
					datab_b << [d.stock_name, d.bse_code, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy] if d.profit_percent >= 10
				elsif d.strategy % 10 == 2
					datab_b << [d.stock_name, d.bse_code, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy] if d.profit_percent >= 2
				elsif d.strategy % 10 != 7 and d.strategy % 10 != 2
					datab_b << [d.stock_name, d.bse_code, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy]
				end
			end		
		end		

		datab_s = [["Name", "BSE Code" , "Profit Percent", "Last_close", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close", "Strategy"]]
		
		datab_s_all = BseBsStrategy.where("bs_signal = -1").order("profit_percent asc").limit(10)
		datab_s_all.each do |d|
			if data.include?(d.strategy)
				if d.strategy % 10 == 7
					datab_s << [d.stock_name, d.bse_code, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy] if d.profit_percent <= -10
				elsif d.strategy % 10 == 2
					datab_s << [d.stock_name, d.bse_code, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy] if d.profit_percent <= -2
				elsif d.strategy % 10 != 7 and d.strategy % 10 != 2
					datab_s << [d.stock_name, d.bse_code, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy]
				end
			end
		end	
		
		datan_b = [["Name", "Profit Percent", "Last_close", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close", "Strategy"]]
		datan_b_all = NseBsStrategy.where("bs_signal = 1").order("profit_percent desc").limit(10)
		datan_b_all.each do |d|
			if data.include?(d.strategy)
				if d.strategy % 10 == 7
					datan_b << [d.stock_name, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy] if d.profit_percent >= 10
				elsif d.strategy % 10 == 2
					datan_b << [d.stock_name, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy] if d.profit_percent >= 2
				elsif d.strategy % 10 != 7 and d.strategy % 10 != 2
					datan_b << [d.stock_name, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy] 
				end
			end
		end
		
		datan_s = [["Name", "Profit Percent", "Last_close", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close", "Strategy"]]
		datan_s_all = NseBsStrategy.where("bs_signal = -1").order("profit_percent asc").limit(10)
		datan_s_all.each do |d|
			if data.include?(d.strategy)
				if d.strategy % 10 == 7
					datan_s << [d.stock_name, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy] if d.profit_percent <= -10
				elsif d.strategy % 10 == 2
					datan_s << [d.stock_name, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy] if d.profit_percent <= -2
				elsif d.strategy % 10 != 7 and d.strategy % 10 != 2
					datan_s << [d.stock_name, d.profit_percent, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy]
				end
			end
		end
		
		

		CSV.open("error_files/strategy.csv", "wb") do |csv|
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

