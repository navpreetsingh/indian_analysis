require 'csv'
require 'open-uri'

class BseStocksDetail < ActiveRecord::Base
	belongs_to :bse_stock
	validates :date, uniqueness: { scope: :bse_stock_id}

	def self.auto
		# BseStocksDetail.update_imp_data
		# BseStocksDetail.spread
		BseTrend.trend
		BseBsStrategy.strategy
		BseBsStrategy.csv_op
		BseDump.update_data
		#BseStock.category
		#BseStocksDetail.spread_new
	end
	

	def self.spread
		ids = BseStock.where("vol_category >= 3").collect(&:id)	
		file = File.new("Bse_spread", "w+")			
		ids.each do |stock|
			begin
				data = BseStocksDetail.where("bse_stock_id = ?", stock).order("date DESC").limit(2)
				for i in 0..data.count - 2
					dt = data[i]
					dy = data[i+1]				
					dy_ch = (((dt.high - dy.close) / dy.close)*100).round(2).to_f
					dy_cl = (((dt.low - dy.close) / dy.close)*100).round(2).to_f
					dy_cc = (((dt.close - dy.close) / dy.close)*100).round(2).to_f
					dy_lco = (((dt.open - dy.close) / dy.close)*100).round(2).to_f
					dt.update_attributes(:lco_diff => dy_lco, :ch_diff => dy_ch, 
						:cl_diff => dy_cl, :cc_diff => dy_cc)			
				end
			rescue Exception => e
				file.syswrite (e.message)
				file.syswrite ("\nStock: #{d[1]}\n")				
				file.syswrite("\nData: #{d}\n\n\n\n\n")
			end
		end
		file.close
	end

	def self.spread_new
		ids = BseStock.where("vol_category >= 3").collect(&:id)	
		file = File.new("Bse_spread_new", "w+")			
		ids.each do |stock|
			begin
				data = BseStocksDetail.where("bse_stock_id = ?", stock).order("date DESC")
				for i in 0..data.count - 2
					dt = data[i]
	 				dy = data[i+1]
	 				dt_oh = (((dt.high - dt.open) / dt.open)*100).round(2).to_f
	 				dt_ol = (((dt.low - dt.open) / dt.open)*100).round(2).to_f
	 				dt_oc = (((dt.close - dt.open) / dt.open)*100).round(2).to_f
	 				bs = dt_oc > 0 ? 1 : -1
	 				dy_ch = (((dt.high - dy.close) / dy.close)*100).round(2).to_f
	 				dy_cl = (((dt.low - dy.close) / dy.close)*100).round(2).to_f
	 				dy_cc = (((dt.close - dy.close) / dy.close)*100).round(2).to_f
	 				dt.update_attributes(:bs_signal => bs, :oh_diff => dt_oh, :ol_diff => dt_ol,
	 					:oc_diff => dt_oc, :ch_diff => dy_ch, :cl_diff => dy_cl, :cc_diff => dy_cc)			
				end
			rescue Exception => e
				file.syswrite (e.message)
				file.syswrite ("\nStock: #{d[1]}\n")				
				file.syswrite("\nData: #{d}\n\n\n\n\n")
			end
		end
		file.close
	end
	
	def self.update_imp_data		
		#data = CSV.read("/home/navpreet/Downloads/bhav_copy/bse_bhav_copy.csv")
		data = CSV.read("/home/trantor/Downloads/bhav_copy/bse_bhav_copy.csv")
		data.delete_at(0)
		stocks = BseStock.where("vol_category >= 3")
		s_codes = stocks.collect(&:bse_code)		
		date = Time.now.strftime("%Y-%m-%d")
		file = File.new("Bse_imp_data", "w+")		
		data.each do |d|
			begin				
				#debugger
				if d[3] == "Q" and s_codes.include?(d[0].to_i)					
					id = stocks.find_by_bse_code(d[0]).id
					dt_oh = (((d[5].to_f - d[4].to_f) / d[4].to_f)*100).round(2).to_f
					dt_ol = (((d[6].to_f - d[4].to_f) / d[4].to_f)*100).round(2).to_f
					dt_oc = (((d[7].to_f - d[4].to_f) / d[4].to_f)*100).round(2).to_f
					bs = dt_oc > 0 ? 1 : -1
					BseStocksDetail.create(:bse_stock_id => id,
						:date => date, :open => d[4], :high => d[5], :low => d[6], :close => d[7],
						:volume => d[11], :no_of_trades => d[10], :total_turnover => d[12],
						:bs_signal => bs, :oh_diff => dt_oh, :ol_diff => dt_ol,
						:oc_diff => dt_oc)									
				end
			rescue Exception => e
				file.syswrite (e.message)
				file.syswrite ("\nStock: #{d[1]}\n")				
				file.syswrite("\nData: #{d}\n\n\n\n\n")
			end
		end
		file.close
	end
end
