require 'csv'
require 'open-uri'
class NseStocksDetail < ActiveRecord::Base
	belongs_to :nse_stock
	validates :date, uniqueness: { scope: :nse_stock_id}

	def self.auto
		NseStocksDetail.update_imp_data
		NseStocksDetail.spread
		NseTrend.trend
		NseBsStrategy.strategy
		NseDump.update_data
		#NseStock.category
		# NseStocksDetail.spread_new
	end

	def self.spread		
		ids = NseStock.where("vol_category >= 3").collect(&:id)
		file = File.new("Nse_spread", "w+")			
		ids.each do |stock|
			begin

				data = NseStocksDetail.where("nse_stock_id = ?", stock).order("date DESC").limit(2)
				for i in 0..data.count - 2
					dt = data[i]
					dy = data[i+1]				
					dy_ch = (((dt.high - dy.close) / dy.close)*100).round(2).to_f
					dy_cl = (((dt.low - dy.close) / dy.close)*100).round(2).to_f
					dy_cc = (((dt.close - dy.close) / dy.close)*100).round(2).to_f
					dy_lco = (((dt.open - dy.close) / dy.close)*100).round(2).to_f
					dt.update_attributes(:lco_diff => dy_lco, :ch_diff => dy_ch, :cl_diff => dy_cl, :cc_diff => dy_cc)			
				end
			rescue Exception => e
				file.syswrite (e.message)
				file.syswrite ("\nStock: #{d[1]}\n")				
				file.syswrite("\nData: #{d}\n\n\n\n\n")
			end	
		end
	end	

	def self.spread_new		
		ids = NseStock.where("vol_category >= 3").collect(&:id)
		file = File.new("Nse_spread", "w+")			
		ids.each do |stock|
			begin
				data = NseStocksDetail.where("nse_stock_id = ?", stock).order("date DESC")
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
	end	

	def self.update_imp_data
		#data = CSV.read("/home/navpreet/Downloads/bhav_copy/nse_bhav_copy.csv")
		data = CSV.read("/home/trantor/Downloads/bhav_copy/nse_bhav_copy.csv")
		data.delete_at(0)
		stocks = NseStock.where("vol_category >= 3")
		s_names = stocks.collect(&:stock_name)
		date = Time.now.strftime("%Y-%m-%d")
		#date = "2014-07-16"
		file = File.new("Nse_imp_data", "w+")		
		data.each do |d|
			begin				
				if s_names.include?(d[0])					
					id = stocks.find_by_stock_name(d[0]).id
					dt_oh = (((d[3].to_f - d[2].to_f) / d[2].to_f)*100).round(2).to_f
					dt_ol = (((d[4].to_f - d[2].to_f) / d[2].to_f)*100).round(2).to_f
					dt_oc = (((d[5].to_f - d[2].to_f) / d[2].to_f)*100).round(2).to_f
					bs = dt_oc > 0 ? 1 : -1
					NseStocksDetail.create(:nse_stock_id => id,
						:date => date, :open => d[2], :high => d[3], :low => d[4], :close => d[5],
						:volume => d[8], :turnover => d[9], :bs_signal => bs, 
						:oh_diff => dt_oh, :ol_diff => dt_ol, :oc_diff => dt_oc)								
				end
			rescue Exception => e
				file.syswrite (e.message)
				file.syswrite ("\nStock: #{d[1]}\n")				
				file.syswrite("\nData: #{d}\n\n\n\n")
			end	
		end
	end
end
