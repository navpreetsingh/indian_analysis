class NseTrend < ActiveRecord::Base
	belongs_to :nse_stock
	validates :date, uniqueness: { scope: :nse_stock_id}

	def self.trend
		# Run below 2 commands before calling this function
		# rake db:migrate:down VERSION=20140705140950
		# rake db:migrate:down VERSION=20140705140950
		file = File.new("Nse_Trend", "w+")
		NseTrend.destroy_all
		ids = NseStock.where("vol_category >= 3")
		ids.each do |stock|
			begin
				data = NseStocksDetail.where("nse_stock_id = ?", stock.id).order("date DESC").limit(30)
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

				#taking averages
				avg_o = data.collect(&:lco_diff)[0..30/(2**3) - 1].sum / 3
				avg_h = data.collect(&:ch_diff)[0..30/(2**3) - 1].sum / 3
				avg_l = data.collect(&:cl_diff)[0..30/(2**3) - 1].sum / 3
				avg_c = data.collect(&:cc_diff)[0..30/(2**3) - 1].sum / 3

				NseTrend.create(:nse_stock_id => stock.id, :stock_name => stock.stock_name,
					:date => data[0].date, :vol_category => stock.vol_category,
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
			rescue Exception => e
				file.syswrite (e.message)
				file.syswrite ("\n Stock: #{stock.stock_name}\n")				
				file.syswrite("\nData: #{data.to_a}\n\n\n\n\n")
			end
		end					
	end
end
