require 'csv'

class NseBsStrategy < ActiveRecord::Base
belongs_to :Nse_stock
validates :stock_name, uniqueness: true

	def self.strategy
		#For best BUYERS
		NseBsStrategy.destroy_all
		data = NseTrend.order("avg_high desc")
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
				
				NseBsStrategy.create(:stock_name => d.stock_name, :nse_stock_id => d.nse_stock_id,
					:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
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
		data = NseTrend.order("avg_low asc")
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

				NseBsStrategy.create(:stock_name => d.stock_name, :nse_stock_id => d.nse_stock_id,
					:date => d.date, :vol_category => d.vol_category, :last_close => d.last_close,
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
end
