require 'csv'
require 'open-uri'

class BseStocksDetail < ActiveRecord::Base
	belongs_to :bse_stock
	validates :date, uniqueness: { scope: :bse_stock_id}

	def self.auto
		BseStocksDetail.update_data
		BseStocksDetail.spread
		BseTrend.trend
		BseBsStrategy.strategy1
		BseBsStrategy.strategy2
		BseBsStrategy.strategy3
	end
	

	def self.spread
		ids = BseStock.where("vol_category >= 3").collect(&:id)			
		ids.each do |stock|
			data = BseStocksDetail.where("bse_stock_id = ?", stock).order("date DESC").limit(2)
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
		data = CSV.read("/home/navpreet/Downloads/bhav_copy/bse_bhav_copy.csv")
		data.delete_at(0)
		stocks = BseStock.all
		s_names = stocks.collect(&:stock_name)
		date = Time.now.strftime("%Y-%m-%d")
		date1 = Time.now.strftime("%m/%d/%Y")
		s = 1
		data.each do |d|
			if d[3] == "Q" 				
				if s_names.include?(d[1])
					id = stocks.find_by_stock_name(d[1]).id
					BseStocksDetail.create(:bse_stock_id => id,
					:date => date, :open => d[4], :high => d[5], :low => d[6], :close => d[7],
					:volume => d[11], :no_of_trades => d[10], :total_turnover => d[12])
				elsif d[11].to_i > 50000
					BseStock.create(:stock_name => d[1])
					id = BseStock.last.id
					file = open("http://www.bseindia.com/stockinfo/stockprc2_excel.aspx?scripcd=#{d[0]}&FromDate=01/01/2009&ToDate=#{date1}&OldDMY=D")
					stock_data = file.read	
					stock_data = CSV.parse(stock_data)
					stock_data.delete([])
					stock_data.delete_at(0)
					stock_data = stock_data.reverse	
					stock_data.each do |s|					
							BseStocksDetail.create(:bse_stock_id => id,
								:date => date, :open => d[4], :high => d[5], :low => d[6], :close => d[7],
								:volume => d[11], :no_of_trades => d[10], :total_turnover => d[12])
					end
				end
			end	
			s += 1
		end
	end
end
