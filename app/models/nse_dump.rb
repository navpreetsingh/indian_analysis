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
		file = File.new("error_files/NseDump", "w+")
		data.each do |d|
			begin				 
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
			rescue Exception => e
				file.syswrite (e.message)
				file.syswrite ("\n Stock: #{d[1]}\n")				
				file.syswrite("\nData: #{d.to_a}\n\n\n\n\n")
			end		
		end
		file.close
	end

	def self.not_getting_updated
		id = NseStock.uniq.pluck(:id)
		date = 1.day.ago.strftime("%Y-%m-%d")
		idbd = NseDump.where("date = ?", date).collect(&:nse_stock_id)
		not_updated = id - idbd
		data = [["stock_id", "stock_name", "last_updated_at"]]
		not_updated.each do |nu|
			d = NseDump.where("nse_stock_id = ?", nu).last.date
			dd = NseStock.find(nu)
			data << [nu, dd.stock_name, d]
		end		
		CSV.open("error_files/nse_not_updated.csv", "wb") do |csv|
			data.each do |d|
				csv << d
			end
		end
	end

	def self.update_nu_data
		id = NseStock.uniq.pluck(:id)
		date = 1.day.ago.strftime("%Y-%m-%d")
		idbd = NseDump.where("date = ?", date).collect(&:nse_stock_id)
		not_updated = id - idbd
		datel = Time.now.strftime("%d-%b-%Y")
		not_updated.each do |nu|
			d = NseDump.where("nse_stock_id = ?", nu).last.date
			datef = (d + 1).strftime("%d-%b-%Y")
			dd = NseStock.find(nu)			
			file = open("http://www.nseindia.com/live_market/dynaContent/live_watch/get_quote/getHistoricalData.jsp?symbol=#{dd.stock_name}&fromDate=#{datef}&toDate=#{datel}&datePeriod=unselected&hiddDwnld=true")			
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
end
