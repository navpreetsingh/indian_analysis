
class BseTrend < ActiveRecord::Base
	belongs_to :bse_stock
	validates :date, uniqueness: { scope: :bse_stock_id}

	def self.trend
		ids = BseStock.where("vol_category >= 3")
		file = File.new("Bse_Trend", "w+")
		date = BseStocksDetail.uniq.pluck(:date).sort.last
		#date = Date.today
		#date = Date.yesterday
		ids.each do |stock|	
			begin	
				data = BseStocksDetail.where("bse_stock_id = ?", stock.id).order("date DESC").limit(30)				
				if data[0].date == date
					data_t = data.collect(&:bs_signal)
					data_h = data.collect(&:high)
					data_l = data.collect(&:low)
					data_c = data.collect(&:close)
					
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

					data_ao = data.collect(&:lco_diff)
					data_ah = data.collect(&:oh_diff)
					data_al = data.collect(&:ol_diff)
					data_ac = data.collect(&:oc_diff)
					
					#taking averages
					avg_o = (data_ao[0] * 0.5) + (data_ao[1] * 0.334) + (data_ao[2] * 0.2)
					avg_h = (data_ah[0] * 0.5) + (data_ah[1] * 0.334) + (data_ah[2] * 0.2)
					avg_l = (data_al[0] * 0.5) + (data_al[1] * 0.334) + (data_al[2] * 0.2)
					avg_c = (data_ac[0] * 0.5) + (data_ac[1] * 0.334) + (data_ac[2] * 0.2)

					BseTrend.create(:bse_stock_id => stock.id, :stock_name => stock.stock_name,
						:bse_code => stock.bse_code, :date => data[0].date, :vol_category => stock.vol_category,
						:d30_t => data_ti[0], :d_30_hi => data_hi[0],
						:d_30_li => data_li[0], :d_30_chi => data_chi[0], :d_30_cli	=> data_cli[0], 
						:d15_t => data_ti[1], :d_15_hi => data_hi[1], :d_15_li => data_li[1], 
						:d_15_chi => data_chi[1], :d_15_cli	=> data_cli[1],
						:d7_t => data_ti[2], :d_7_hi => data_hi[2], :d_7_li => data_li[2], 
						:d_7_chi => data_chi[2], :d_7_cli	=> data_cli[2],
						:d3_t => data_ti[3], :d_3_hi => data_hi[3], :d_3_li => data_li[3], 
						:d_3_chi => data_chi[3], :d_3_cli	=> data_cli[3],
						:bs_signal => data[0].bs_signal, :last_close => data[0].close,
						:avg_open => avg_o, :avg_high => avg_h, :avg_low => avg_l, 
						:avg_close => avg_c )
				end
			rescue Exception => e
				file.syswrite (e.message)
				file.syswrite ("\n Stock: #{stock}\n")				
				file.syswrite("\nData: #{data}\n\n\n\n\n")
			end
		end	
		file.close				
	end
end
