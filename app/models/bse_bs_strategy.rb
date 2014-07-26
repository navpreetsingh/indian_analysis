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
				debugger if stp.nil?
				st = 40 + stp
				st = 10 + stp if d.d3_t == 3 and d.d7_t > 0 and d.d15_t > 0 and d.d30_t >= 0
				st = 20 + stp if d.d3_t == 1 and d.d7_t > 0 and d.d15_t > 0 and d.d30_t >= 0 and d.bs_signal = 1
				st = 30 + stp if d.d3_t == -1 and d.d7_t > 0 and d.d15_t > 0 and d.d30_t >= 0 and d.bs_signal = 1
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
			if (-1 * d.avg_low) > d.avg_high
				if d.avg_low < -10
					if d.avg_high < 0
						d.avg_high = -1 if d.avg_high < -1
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close * 0.99
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.97
						stp = 1
					elsif d.avg_high > 0 and d.avg_low < 1
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close 
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.975
						stp = 3
					else
						target1 = d.last_close * 0.98
						stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
						target2 = d.last_close * 0.965
						stop_loss2 = d.last_close 
						target3 = d.last_close * 0.95
						stop_loss3 = d.last_close * 0.98
						stp = 5
					end
				else
					if d.avg_high < 0
						d.avg_high = -1 if d.avg_high < -1
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close * (1 - ((d.avg_high)/100))
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 1.25)/100))
						stp = 2
					elsif d.avg_high > 0 and d.avg_high < 1
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close  
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.2)/100))
						stp = 4
					else
						target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
						stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
						target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
						stop_loss2 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
						target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
						stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.25)/100))
						stp = 6
					end
				end
				st = 40 + stp
				st = 10 + stp if d.d3_t == -3
				st = 20 + stp if d.d3_t == -1 and d.d7_t < 0 and d.bs_signal = -1
				st = 30 + stp if d.d3_t == 1 and d.d7_t < 0 and d.d15_t < 0 and d.bs_signal = -1
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
		data = [11, 13, 15, 21, 23, 25, 31, 33, 35, ]
		datab_b = [["Name", "BSE Code" , "Last_close", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close", "Strategy"]]
		data.each do |dd|
			datab_b_all = BseBsStrategy.where("strategy = ? AND bs_signal = 1", dd)
			datab_b_all.each do |d|
				datab_b << [d.stock_name, d.bse_code, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy]
			end
		end

		datab_s = [["Name", "BSE Code" , "Last_close", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close", "Strategy"]]
		data.each do |dd|
			datab_s_all = BseBsStrategy.where("strategy = ? AND bs_signal = -1", dd)
			datab_s_all.each do |d|
				datab_s << [d.stock_name, d.bse_code, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy]
			end
		end


		datan_b = [["Name", "Last_close", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close", "Strategy"]]
		data.each do |dd|
			datan_b_all = NseBsStrategy.where("strategy = ? AND bs_signal = 1", dd)
			datan_b_all.each do |d|
				datan_b << [d.stock_name, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy]
			end
		end

		datan_s = [["Name", "Last_close", "Target 1", "Stop Loss 1", "Target 2", "Stop Loss 2", "Target 3", "Stop Loss 3", "Expected Open", "Expected High", "Expected Low", "Expected Close", "Strategy"]]
		data.each do |dd|
			datan_s_all = NseBsStrategy.where("strategy = ? AND bs_signal = -1", dd)
			datan_s_all.each do |d|
				datan_s << [d.stock_name, d.last_close, d.target_1, d.stop_loss_1, d.target_2, d.stop_loss_2, d.target_3, d.stop_loss_3, d.open, d.high, d.low, d.close, d.strategy]
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


# def self.strategy1
# 		#For best BUYERS
# 		data = BseTrend.where("d3_t = 3").order("avg_high desc").limit(30)
# 		st = 1
# 		data.each do |d|
# 			if d.avg_high > 10 
# 				if d.avg_low > 0
# 					target1 = d.last_close * 1.02
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * 1.035
# 					stop_loss2 = d.last_close * 1.01
# 					target3 = d.last_close * 1.05
# 					stop_loss3 = d.last_close * 1.03
# 				elsif d.avg_low < 0 and d.avg_low > -1
# 					target1 = d.last_close * 1.02
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
# 					target2 = d.last_close * 1.035
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 1.05
# 					stop_loss3 = d.last_close * 1.025
# 				else
# 					target1 = d.last_close * 1.02
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
# 					target2 = d.last_close * 1.035
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 1.05
# 					stop_loss3 = d.last_close * 1.02
# 				end
# 			else
# 				if d.avg_low > 0
# 					d.avg_low = 1 if d.avg_low > 1
# 					target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 + ((d.avg_low)/100))
# 					target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
# 				elsif d.avg_low < 0 and d.avg_low > -1
# 					target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
# 					target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
# 					stop_loss2 = d.last_close  
# 					target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.2)/100))
# 				else
# 					target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
# 					target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.25)/100))
# 				end
# 			end
# 			BseBsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
# 				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
# 				:bs_signal => 1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
# 				:high => (d.last_close * (1 + (d.avg_high / 100))), 
# 				:low => (d.last_close * (1 + (d.avg_low / 100))),
# 				:close => (d.last_close * (1 + (d.avg_close / 100))),
# 				:target_1 => target1, :stop_loss_1 => stop_loss1,
# 				:target_2 => target2, :stop_loss_2 => stop_loss2,
# 				:target_3 => target3, :stop_loss_3 => stop_loss3,
# 				:rank => st, :strategy => 1)
# 			st += 1
# 		end	

# 		#For best sellers
# 		data = BseTrend.where("d3_t = -3").order("avg_low asc").limit(30)
# 		st = 1
# 		data.each do |d|				
# 			if d.avg_low < -10
# 				if d.avg_high < 0
# 					d.avg_high = -1 if d.avg_high < -1
# 					target1 = d.last_close * 0.98
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * 0.965
# 					stop_loss2 = d.last_close * 0.99
# 					target3 = d.last_close * 0.95
# 					stop_loss3 = d.last_close * 0.97
# 				elsif d.avg_high > 0 and d.avg_low < 1
# 					target1 = d.last_close * 0.98
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
# 					target2 = d.last_close * 0.965
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 0.95
# 					stop_loss3 = d.last_close * 0.975
# 				else
# 					target1 = d.last_close * 0.98
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
# 					target2 = d.last_close * 0.965
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 0.95
# 					stop_loss3 = d.last_close * 0.98
# 				end
# 			else
# 				if d.avg_high < 0
# 					d.avg_high = -1 if d.avg_high < -1
# 					target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 - ((d.avg_high)/100))
# 					target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_high * 1.25)/100))
# 				elsif d.avg_high > 0 and d.avg_high < 1
# 					target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
# 					target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
# 					stop_loss2 = d.last_close  
# 					target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.2)/100))
# 				else
# 					target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
# 					target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.25)/100))
# 				end
# 			end
# 			BseBsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
# 				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
# 				:bs_signal => -1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
# 				:high => (d.last_close * (1 + (d.avg_high / 100))), 
# 				:low => (d.last_close * (1 + (d.avg_low / 100))),
# 				:close => (d.last_close * (1 + (d.avg_close / 100))),
# 				:target_1 => target1, :stop_loss_1 => stop_loss1,
# 				:target_2 => target2, :stop_loss_2 => stop_loss2,
# 				:target_3 => target3, :stop_loss_3 => stop_loss3,
# 				:rank => st, :strategy => 1)
# 			st += 1
# 		end		
# 	end

# 	def self.strategy2
# 		#For best BUYERS
# 		data = BseTrend.where("d3_t = 1 AND d7_t > 0").order("avg_high desc").limit(30)
# 		st = 1
# 		data.each do |d|
# 			if d.avg_high > 10
# 				if d.avg_low > 0
# 					target1 = d.last_close * 1.02
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * 1.035
# 					stop_loss2 = d.last_close * 1.01
# 					target3 = d.last_close * 1.05
# 					stop_loss3 = d.last_close * 1.03
# 				elsif d.avg_low < 0 and d.avg_low > -1
# 					target1 = d.last_close * 1.02
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
# 					target2 = d.last_close * 1.035
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 1.05
# 					stop_loss3 = d.last_close * 1.025
# 				else
# 					target1 = d.last_close * 1.02
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
# 					target2 = d.last_close * 1.035
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 1.05
# 					stop_loss3 = d.last_close * 1.02
# 				end
# 			else
# 				if d.avg_low > 0
# 					d.avg_low = 1 if d.avg_low > 1
# 					target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 + ((d.avg_low)/100))
# 					target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
# 				elsif d.avg_low < 0 and d.avg_low > -1
# 					target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
# 					target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
# 					stop_loss2 = d.last_close  
# 					target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.2)/100))
# 				else
# 					target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
# 					target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.25)/100))
# 				end
# 			end
# 			BseBsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
# 				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
# 				:bs_signal => 1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
# 				:high => (d.last_close * (1 + (d.avg_high / 100))), 
# 				:low => (d.last_close * (1 + (d.avg_low / 100))),
# 				:close => (d.last_close * (1 + (d.avg_close / 100))),
# 				:target_1 => target1, :stop_loss_1 => stop_loss1,
# 				:target_2 => target2, :stop_loss_2 => stop_loss2,
# 				:target_3 => target3, :stop_loss_3 => stop_loss3,
# 				:rank => st, :strategy => 2)
# 			st += 1
# 		end	

# 		#For best sellers
# 		data = BseTrend.where("d3_t = -1 AND d7_t < 0").order("avg_low asc").limit(30)
# 		st = 1
# 		data.each do |d|				
# 			if d.avg_low < -10
# 				if d.avg_high < 0
# 					d.avg_high = -1 if d.avg_high < -1
# 					target1 = d.last_close * 0.98
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * 0.965
# 					stop_loss2 = d.last_close * 0.99
# 					target3 = d.last_close * 0.95
# 					stop_loss3 = d.last_close * 0.97
# 				elsif d.avg_high > 0 and d.avg_low < 1
# 					target1 = d.last_close * 0.98
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
# 					target2 = d.last_close * 0.965
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 0.95
# 					stop_loss3 = d.last_close * 0.975
# 				else
# 					target1 = d.last_close * 0.98
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
# 					target2 = d.last_close * 0.965
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 0.95
# 					stop_loss3 = d.last_close * 0.98
# 				end
# 			else
# 				if d.avg_high < 0
# 					target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 - ((d.avg_high)/100))
# 					target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_high * 1.25)/100))
# 				elsif d.avg_high > 0 and d.avg_high < 1
# 					target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
# 					target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
# 					stop_loss2 = d.last_close  
# 					target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.2)/100))
# 				else
# 					target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
# 					target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.25)/100))
# 				end
# 			end
# 			BseBsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
# 				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
# 				:bs_signal => -1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
# 				:high => (d.last_close * (1 + (d.avg_high / 100))), 
# 				:low => (d.last_close * (1 + (d.avg_low / 100))),
# 				:close => (d.last_close * (1 + (d.avg_close / 100))),
# 				:target_1 => target1, :stop_loss_1 => stop_loss1,
# 				:target_2 => target2, :stop_loss_2 => stop_loss2,
# 				:target_3 => target3, :stop_loss_3 => stop_loss3,
# 				:rank => st, :strategy => 2)
# 			st += 1
# 		end			
# 	end

# 	def self.strategy3
# 		#For best BUYERS
# 		data = BseTrend.where("d3_t = -1 AND d7_t > 0 AND d15_t > 0").order("avg_high desc").limit(30)
# 		st = 1
# 		data.each do |d|
# 			if d.avg_high > 10
# 				if d.avg_low > 0
# 					target1 = d.last_close * 1.02
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * 1.035
# 					stop_loss2 = d.last_close * 1.01
# 					target3 = d.last_close * 1.05
# 					stop_loss3 = d.last_close * 1.03
# 				elsif d.avg_low < 0 and d.avg_low > -1
# 					target1 = d.last_close * 1.02
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
# 					target2 = d.last_close * 1.035
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 1.05
# 					stop_loss3 = d.last_close * 1.025
# 				else
# 					target1 = d.last_close * 1.02
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
# 					target2 = d.last_close * 1.035
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 1.05
# 					stop_loss3 = d.last_close * 1.02
# 				end
# 			else
# 				if d.avg_low > 0
# 					d.avg_low = 1 if d.avg_low > 1
# 					target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 + ((d.avg_low)/100))
# 					target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
# 				elsif d.avg_low < 0 and d.avg_low > -1
# 					target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low * 1.25)/100))
# 					target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
# 					stop_loss2 = d.last_close  
# 					target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.2)/100))
# 				else
# 					target1 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_low)/100))
# 					target2 = d.last_close * (1 + ((d.avg_high * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					target3 = d.last_close * (1 + ((d.avg_high * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_low * 0.25)/100))
# 				end
# 			end
# 			BseBsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
# 				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
# 				:bs_signal => 1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
# 				:high => (d.last_close * (1 + (d.avg_high / 100))), 
# 				:low => (d.last_close * (1 + (d.avg_low / 100))),
# 				:close => (d.last_close * (1 + (d.avg_close / 100))),
# 				:target_1 => target1, :stop_loss_1 => stop_loss1,
# 				:target_2 => target2, :stop_loss_2 => stop_loss2,
# 				:target_3 => target3, :stop_loss_3 => stop_loss3,
# 				:rank => st, :strategy => 3)
# 			st += 1
# 		end	

# 		#For best sellers
# 		data = BseTrend.where("d3_t = 1 AND d7_t < 0 AND d15_t < 0").order("avg_low asc").limit(30)
# 		st = 1
# 		data.each do |d|				
# 			if d.avg_low < -10
# 				if d.avg_high < 0
# 					d.avg_high = -1 if d.avg_high < -1
# 					target1 = d.last_close * 0.98
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * 0.965
# 					stop_loss2 = d.last_close * 0.99
# 					target3 = d.last_close * 0.95
# 					stop_loss3 = d.last_close * 0.97
# 				elsif d.avg_high > 0 and d.avg_low < 1
# 					target1 = d.last_close * 0.98
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
# 					target2 = d.last_close * 0.965
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 0.95
# 					stop_loss3 = d.last_close * 0.975
# 				else
# 					target1 = d.last_close * 0.98
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
# 					target2 = d.last_close * 0.965
# 					stop_loss2 = d.last_close 
# 					target3 = d.last_close * 0.95
# 					stop_loss3 = d.last_close * 0.98
# 				end
# 			else
# 				if d.avg_high < 0
# 					target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					stop_loss1 = d.last_close
# 					target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 - ((d.avg_high)/100))
# 					target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_high * 1.25)/100))
# 				elsif d.avg_high > 0 and d.avg_high < 1
# 					target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high * 1.25)/100))
# 					target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
# 					stop_loss2 = d.last_close  
# 					target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.2)/100))
# 				else
# 					target1 = d.last_close * (1 + ((d.avg_low * 0.25)/100))
# 					stop_loss1 = d.last_close * (1 + ((d.avg_high)/100))
# 					target2 = d.last_close * (1 + ((d.avg_low * 0.4)/100))
# 					stop_loss2 = d.last_close * (1 + ((d.avg_high * 0.25)/100))
# 					target3 = d.last_close * (1 + ((d.avg_low * 0.5)/100))
# 					stop_loss3 = d.last_close * (1 - ((d.avg_high * 0.25)/100))
# 				end
# 			end
# 			BseBsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
# 				:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
# 				:bs_signal => -1, :open => (d.last_close * ( 1 + (d.avg_open / 100))), 
# 				:high => (d.last_close * (1 + (d.avg_high / 100))), 
# 				:low => (d.last_close * (1 + (d.avg_low / 100))),
# 				:close => (d.last_close * (1 + (d.avg_close / 100))),
# 				:target_1 => target1, :stop_loss_1 => stop_loss1,
# 				:target_2 => target2, :stop_loss_2 => stop_loss2,
# 				:target_3 => target3, :stop_loss_3 => stop_loss3,
# 				:rank => st, :strategy => 1)
# 			st += 1
# 		end		
# 	end
