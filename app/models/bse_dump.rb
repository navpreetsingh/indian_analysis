require 'csv'
require 'open-uri'

class BseDump < ActiveRecord::Base
	belongs_to :bse_stock
	validates :date, uniqueness: { scope: :bse_stock_id}
	
	def self.update_data
		#data = CSV.read("/home/navpreet/Downloads/bhav_copy/bse_bhav_copy.csv")
		data = CSV.read("/home/trantor/Downloads/bhav_copy/bse_bhav_copy.csv")
		data.delete_at(0)
		stocks = BseStock.all
		s_names = stocks.collect(&:stock_name)
		date = Time.now.strftime("%Y-%m-%d")
		date1 = Time.now.strftime("%m/%d/%Y")
		s = 1
		file = File.new("BseDump", "w+")
		data.each do |dt|
			begin
				if dt[3] == "Q" 				
					if s_names.include?(dt[1])
						id = stocks.find_by_stock_name(dt[1]).id					
						BseDump.create(:bse_stock_id => id,
							:date => date, :open => dt[4], :high => dt[5], :low => dt[6], :close => dt[7],
							:volume => dt[11], :no_of_trades => dt[10], :total_turnover => dt[12])
					elsif dt[11].to_i > 50000
						BseStock.create(:stock_name => dt[1],:vol_category => 0)
						id1 = BseStock.last.id
						file = open("http://www.bseindia.com/stockinfo/stockprc2_excel.aspx?scripcd=#{dt[0]}&FromDate=01/01/2009&ToDate=#{date1}&OldDMY=D")
						stock_data = file.read	
						stock_data = CSV.parse(stock_data)
						stock_data.delete([])
						stock_data.delete_at(0)
						stock_data = stock_data.reverse	
						stock_data.each do |s|						
							BseDump.create(:bse_stock_id => id1,
								:date => Date.parse(s[0]).to_s, :open => s[1], :high => s[2], :low => s[3], :close => s[4],
								:volume => s[6], :no_of_trades => s[7], :total_turnover => s[8])
						end
					end
				end	
			rescue Exception => e
				file.syswrite (e.message)
				file.syswrite ("\nStock: #{dt[1]}\n")				
				file.syswrite("\nData: #{dt.to_a}\n\n\n\n\n")
			end		
		end
	end
end
