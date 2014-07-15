require 'csv'
require 'open-uri'

class NseDump < ActiveRecord::Base
	belongs_to :nse_stock
	validates :date, uniqueness: { scope: :nse_stock_id}

	def self.update_data
		#data = CSV.read("/home/navpreet/Downloads/bhav_copy/nse_bhav_copy.csv")
		data = CSV.read("/home/trantor/Downloads/bhav_copy/nse_bhav_copy.csv")
		data.delete_at(0)
		stocks = NseStock.all
		s_names = stocks.collect(&:stock_name)
		date = Time.now.strftime("%Y-%m-%d")
		date1 = Time.now.strftime("%d-%b-%Y")
		file = File.new("NseDump", "w+")
		data.each do |d|
			begin
				if d[1] == "EQ" 
					if s_names.include?(d[0])
						id = stocks.find_by_stock_name(d[0]).id
						NseDump.create(:nse_stock_id => id,
						:date => date, :open => d[2], :high => d[3], :low => d[4], :close => d[5],
						:volume => d[8], :turnover => d[9])
					elsif d[11].to_i > 50000
						NseStock.create(:stock_name => d[0], :vol_category => 0)
						id1 = NseStock.last.id
						stock = stock.gsub("&", "%26") if stock.include?("&")
						file = open("http://www.nseindia.com/live_market/dynaContent/live_watch/get_quote/getHistoricalData.jsp?symbol=#{d[0]}&fromDate=01-Jan-2009&toDate=#{date1}&datePeriod=unselected&hiddDwnld=true")
						stock_data = file.read	
						stock_data = CSV.parse(stock_data)
						stock_data.delete([])
						stock_data.delete_at(0)
						stock_data = stock_data.reverse	
						stock_data.each do |s|					
								NseDump.create(:nse_stock_id => id1,
									:date => date, :open => d[2], :high => d[3], :low => d[4], :close => d[5],
									:volume => d[8], :turnover => d[9])
						end
					end
				end
			rescue Exception => e
				file.syswrite (e.message)
				file.syswrite ("\n Stock: #{d[1]}\n")				
				file.syswrite("\nData: #{d.to_a}\n\n\n\n\n")
			end		
		end
	end
end
