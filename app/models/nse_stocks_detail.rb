require 'csv'
require 'open-uri'
class NseStocksDetail < ActiveRecord::Base
	belongs_to :nse_stock
	validates :date, uniqueness: { scope: :nse_stock_id}

	def self.auto
		#NseStocksDetail.update_data
		NseStocksDetail.spread
		NseTrend.trend
		NseBsStrategy.strategy1
		NseBsStrategy.strategy2
		NseBsStrategy.strategy3
	end

	def self.spread		
		ids = NseStock.where("vol_category >= 3").collect(&:id)			
		ids.each do |stock|
			data = NseStocksDetail.where("nse_stock_id = ?", stock).order("date DESC").limit(2)
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
				dy_lco = (((dt.open - dy.close) / dy.close)*100).round(2).to_f
				dt.update_attributes(:bs_signal => bs, :oh_diff => dt_oh, :ol_diff => dt_ol,
					:oc_diff => dt_oc, :lco_diff => dy_lco, :ch_diff => dy_ch, :cl_diff => dy_cl, :cc_diff => dy_cc)			
			end
		end
	end

	def self.update_data
		data = CSV.read("/home/navpreet/Downloads/bhav_copy/nse_bhav_copy.csv")
		data.delete_at(0)
		stocks = NseStock.all
		s_names = stocks.collect(&:stock_name)
		date = Time.now.strftime("%Y-%m-%d")
		date1 = Time.now.strftime("%d-%b-%Y")
		data.each do |d|
			if d[1] == "EQ" 
				if s_names.include?(d[0])
					id = stocks.find_by_stock_name(d[0]).id
					NseStocksDetail.create(:nse_stock_id => id,
					:date => date, :open => d[2], :high => d[3], :low => d[4], :close => d[5],
					:volume => d[8], :turnover => d[9])
				elsif d[11].to_i > 50000
					NseStock.create(:stock_name => d[0])
					id = NseStock.last.id
					stock = stock.gsub("&", "%26") if stock.include?("&")
					file = open("http://www.nseindia.com/live_market/dynaContent/live_watch/get_quote/getHistoricalData.jsp?symbol=#{d[0]}&fromDate=01-Jan-2009&toDate=#{date1}&datePeriod=unselected&hiddDwnld=true")
					stock_data = file.read	
					stock_data = CSV.parse(stock_data)
					stock_data.delete([])
					stock_data.delete_at(0)
					stock_data = stock_data.reverse	
					stock_data.each do |s|					
							NseStocksDetail.create(:nse_stock_id => id,
								:date => date, :open => d[2], :high => d[3], :low => d[4], :close => d[5],
								:volume => d[8], :turnover => d[9])
					end
				end
			end	
		end
	end
end
