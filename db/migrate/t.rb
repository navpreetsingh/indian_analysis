class Bse4pTrend < ActiveRecord::Base
	belongs_to :bse_stock	
	validates :date, uniqueness: { scope: :bse_stock_id}

	def self.trend4
		# Run below 2 commands before calling this function
		# rake db:migrate:down VERSION=20140705140950
		# rake db:migrate:down VERSION=20140705140950
		
		ids = BseStock.where("vol_category >= 3")
		ids.each do |stock|

			t = Time.now
			data = BseStocksDetail.where("bse_stock_id = ? and date <= '2014-07-15'", stock.id).order("date DESC").limit(31)
			zz = 0

			for cc in zz..data.count - 30
				date = data[cc].date
				bs_signal = data[cc].bs_signal
				last_close = data[cc].close
				data_t = data.collect(&:bs_signal)[cc..cc+29]
				data_h = data.collect(&:high)[cc..cc+29]
				data_l = data.collect(&:low)[cc..cc+29]
				data_c = data.collect(&:close)[cc..cc+29]
				
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
				avg_hh = data.collect(&:ch_diff)[cc..cc+29]
				avg_ll = data.collect(&:cl_diff)[cc..cc+29]
				avg_cc = data.collect(&:cc_diff)[cc..cc+29]
				avg_h = avg_hh[0..30/(2**3) - 1].sum / 3
				avg_l = avg_ll[0..30/(2**3) - 1].sum / 3
				avg_c = avg_cc[0..30/(2**3) - 1].sum / 3

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
					:avg_high => avg_h, :avg_low => avg_l, :avg_close => avg_c )

				zz += 1
			end	
			puts Time.now - t
		#end				
	end	
end