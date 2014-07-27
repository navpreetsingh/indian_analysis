class Bse4BsStrategy < ActiveRecord::Base
	belongs_to :bse_stock
	validates :date, uniqueness: { scope: :bse_stock_id}

	def self.strategy
		#dates = Bse4pTrend.uniq.pluck(:date).sort.last
		
		#dates.each do |date|
		#dates.each do |date|
		
		#For best buyers
			data = Bse4pTrend.order("avg_high desc")
			rank = 1
			data.each do |d|
				open = (d.last_close * ( 1 + (d.avg_open / 100)))
				if d.avg_high > (-1 * d.avg_low)
					if d.avg_high > 10 
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
							stp = 7 if d.avg_low <= -2
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
					new_d =  BseStocksDetail.where("bse_stock_id = ? AND date > ?", d.bse_stock_id, d.date).first
					unless new_d.nil?
						shares_bought = (10000 / new_d.open).to_i

						pl = (new_d.close - new_d.open) * shares_bought
						if ((new_d.close - new_d.low) > (new_d.high - new_d.close))
							if new_d.low < stop_loss1
								pl = (stop_loss1 - new_d.open) * shares_bought
							elsif new_d.high > target1 and new_d.close < stop_loss2
								pl = (stop_loss2 - new_d.open) * shares_bought
							elsif new_d.high > target2 and new_d.close < stop_loss3
								pl = (stop_loss3 - new_d.open) * shares_bought
							end							
						else
							if new_d.high > target2 and new_d.close < stop_loss3
								pl = (stop_loss3 - new_d.open) * shares_bought
							elsif new_d.high > target1 and new_d.close < stop_loss2
								pl = (stop_loss2 - new_d.open) * shares_bought
							elsif new_d.high < target1 and new_d.low < stop_loss1 
								pl = (stop_loss1 - new_d.open) * shares_bought
							end
						end

						pl = 0 if new_d.open > (open * (1 + (d.avg_high / 100)))											
						# if new_d.low > stop_loss3
						# 	pl = (new_d.close - new_d.open) * shares_bought
						# elsif new_d.low < stop_loss3 and new_d.low > stop_loss2
						# 	pl = (stop_loss3 - new_d.open) * shares_bought
						# elsif new_d.low < stop_loss2 and new_d.low > stop_loss1
						# 	pl = (stop_loss2 - new_d.open) * shares_bought
						# else
						# 	pl = (stop_loss1 - new_d.open) * shares_bought
						# end
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

						Bse4BsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
							:date => d.date, :executed_date => new_d.date, :last_close => open,
							:bs_signal => 1, :open => new_d.open, :high => new_d.high, 
							:low => new_d.low, :close => new_d.close, :target_1 => target1, 
							:stop_loss_1 => stop_loss1, :target_2 => target2, :stop_loss_2 => stop_loss2,
							:target_3 => target3, :stop_loss_3 => stop_loss3, :profit_loss => pl,
							:rank => rank, :strategy => st)
						rank += 1
					end
				end
			end
		#end

		#For best sellers
			data = Bse4pTrend.order("avg_low asc")
			rank = 1
			data.each do |d|
				open = (d.last_close * ( 1 + (d.avg_open / 100)))	
				if (-1 * d.avg_low) > d.avg_high
					if d.avg_low < -10
						if d.avg_high < 0
							d.avg_high = -1 if d.avg_high < -1
							target1 = open * 0.98
							stop_loss1 = open
							target2 = open * 0.965
							stop_loss2 = open * 0.99
							target3 = open * 0.95
							stop_loss3 = open * 0.97
							stp = 1
						elsif d.avg_high > 0 and d.avg_high < 1
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

					
					new_d =  BseStocksDetail.where("bse_stock_id = ? AND date > ?", d.bse_stock_id, d.date).first
					unless new_d.nil?
						shares_bought = (10000 / new_d.open).to_i

						pl = (new_d.open - new_d.close) * shares_bought
						if ((new_d.close - new_d.low) < (new_d.high - new_d.close))
							if new_d.high > stop_loss1
								pl = (new_d.open - stop_loss1) * shares_bought
							elsif new_d.low < target1 and new_d.close > stop_loss2
								pl = (new_d.open - stop_loss2) * shares_bought
							elsif new_d.low < target2 and new_d.close > stop_loss3
								pl = (new_d.open - stop_loss3) * shares_bought
							end							
						else
							if new_d.low < target2 and new_d.close > stop_loss3
								pl = (new_d.open - stop_loss3) * shares_bought
							elsif new_d.low < target1 and new_d.close > stop_loss2
								pl = (new_d.open - stop_loss2) * shares_bought
							elsif new_d.low > target1 and new_d.high > stop_loss1 
								pl = (new_d.open - stop_loss1) * shares_bought
							end
						end

						pl = 0 if new_d.open < (open * (1 + (d.avg_low / 100)))	


						# if new_d.high > stop_loss3
						# 	pl = (new_d.open - new_d.close) * shares_bought
						# elsif new_d.high > stop_loss2 and new_d.high < stop_loss3
						# 	pl = (new_d.open - stop_loss3) * shares_bought
						# elsif new_d.high > stop_loss1 and new_d.high < stop_loss2
						# 	pl = (new_d.open - stop_loss2) * shares_bought
						# else
						# 	pl = (new_d.open - stop_loss1) * shares_bought
						# end
						Bse4BsStrategy.create(:stock_name => d.stock_name, :bse_stock_id => d.bse_stock_id,
							:date => d.date, :executed_date => new_d.date, :last_close => open,
							:bs_signal => -1, :open => new_d.open, :high => new_d.high, 
							:low => new_d.low, :close => new_d.close, :target_1 => target1, 
							:stop_loss_1 => stop_loss1, :target_2 => target2, :stop_loss_2 => stop_loss2,
							:target_3 => target3, :stop_loss_3 => stop_loss3, :profit_loss => pl,
							:rank => rank, :strategy => st)
						rank += 1
					end
				end				
			end
		#end		
	end	
end
