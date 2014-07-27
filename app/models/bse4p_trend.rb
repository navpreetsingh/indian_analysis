class Bse4pTrend < ActiveRecord::Base
	belongs_to :bse_stock	
	validates :date, uniqueness: { scope: :bse_stock_id}

	def self.auto
		Bse4pTrend.trend
		Bse4BsStrategy.strategy
		StrategyAnalysis.analysis
	end

	def self.trend
		# Run below 2 commands before calling this function
		# rake db:migrate:down VERSION=20140705140950
		# rake db:migrate:down VERSION=20140705140950
		
		ids = BseStock.where("vol_category >= 3")
		t = Time.now.strftime("%Y-%m-%d")
		file = File.new("Bse_testing_trend", "w+")
		ids.each do |stock|		
			begin	
				data = BseStocksDetail.where("bse_stock_id = ? and date <= ?", stock.id, t).order("date DESC").limit(40)
				data_tt = data.collect(&:bs_signal)
				data_hh = data.collect(&:high)
				data_ll = data.collect(&:low)
				data_cc = data.collect(&:close)
				avg_aaoo = data.collect(&:lco_diff)
				avg_hhh = data.collect(&:oh_diff)
				avg_lll = data.collect(&:ol_diff)
				avg_ccc = data.collect(&:oc_diff)

				for cc in 0..(data.count - 30)
					date = data[cc].date
					bs_signal = data[cc].bs_signal
					last_close = data[cc].close
					data_t = data_tt[cc..cc+29]
					data_h = data_hh[cc..cc+29]
					data_l = data_ll[cc..cc+29]
					data_c = data_cc[cc..cc+29]
					
					data_ti = []
					data_hi = []
					data_li = []
					data_chi = []
					data_cli = []
					

					#identify trend and turning of trend
					for i in 0..3
						data_ti << data_t[0..30/(2**i) - 1].sum
						data_hi << data_h[0..30/(2**i) - 1].index(data_h[0..30/(2**i) - 1].max) + 1
						data_li << data_l[0..30/(2**i) - 1].index(data_l[0..30/(2**i) - 1].min) + 1
						data_chi << data_c[0..30/(2**i) - 1].index(data_c[0..30/(2**i) - 1].max) + 1
						data_cli << data_c[0..30/(2**i) - 1].index(data_c[0..30/(2**i) - 1].min) + 1		
					end

					#taking averages
					avg_ao = avg_aaoo[cc..cc+2]
					avg_hh = avg_hhh[cc..cc+2]
					avg_ll = avg_lll[cc..cc+2]
					avg_cc = avg_ccc[cc..cc+2]
					avg_o = (avg_ao[0] * 0.5) + (avg_ao[1] * 0.3) + (avg_ao[2] * 0.2)
					avg_h = (avg_hh[0] * 0.5) + (avg_hh[1] * 0.3) + (avg_hh[2] * 0.2) 
					avg_l = (avg_ll[0] * 0.5) + (avg_ll[1] * 0.3) + (avg_ll[2] * 0.2) 
					avg_c = (avg_cc[0] * 0.5) + (avg_cc[1] * 0.3) + (avg_cc[2] * 0.2) 					

					Bse4pTrend.create(:bse_stock_id => stock.id, :stock_name => stock.stock_name,
						 :date => date,
						:d30_t => data_ti[0], :d_30_hi => data_hi[0], :d_30_li => data_li[0], 
						:d_30_chi => data_chi[0], :d_30_cli	=> data_cli[0], 
						:d15_t => data_ti[1], :d_15_hi => data_hi[1], :d_15_li => data_li[1], 
						:d_15_chi => data_chi[1], :d_15_cli	=> data_cli[1],
						:d7_t => data_ti[2], :d_7_hi => data_hi[2], :d_7_li => data_li[2], 
						:d_7_chi => data_chi[2], :d_7_cli	=> data_cli[2],
						:d3_t => data_ti[3], :d_3_hi => data_hi[3], :d_3_li => data_li[3], 
						:d_3_chi => data_chi[3], :d_3_cli	=> data_cli[3], 
						:bs_signal => bs_signal, :last_close => last_close,
						:avg_open => avg_o,
						:avg_high => avg_h, :avg_low => avg_l, :avg_close => avg_c )

					
				end	
			rescue Exception => e
				file.syswrite (e.message)
				file.syswrite ("\n Stock: #{stock.stock_name}\n")				
				file.syswrite("\nData: #{data.count}\n\n\n\n\n")
			end	
				
		end				
	end	
end