require 'csv'
class NseYearDetail < ActiveRecord::Base

	def self.ranking
		yids = NseYearDetail.where("year = 2014").order("oc_diff desc").limit(200).collect(&:nse_stock_id)
		months = ["May, 2014", "June, 2014", "July, 2014", "August, 2014"]
		weeks = ["2014 Week: 25", "2014 Week: 26", "2014 Week: 27", "2014 Week: 28", "2014 Week: 29", "2014 Week: 30", "2014 Week: 31"]
		mids = []
		wids = []
		data = [["Rank", "Top Year Ids"]]
		months.each do |m|
			data[0] << m
			mids << NseMonthDetail.where("date = ?", m).order("oc_diff desc").collect(&:nse_stock_id)
		end
		weeks.each do |w|
			data[0] << w
			wids << NseWeekDetail.where("date = ?", w).order("oc_diff desc").collect(&:nse_stock_id)
		end
		rank = 1
		yids.each do |y|
			data << [rank, y]
			for i in 0..3
				data[rank] << mids[i].index(y) + 1 unless mids[i].index(y).nil?
			end
			for i in 0..6
				data[rank] << wids[i].index(y) + 1 unless wids[i].index(y).nil?
			end
			rank += 1
		end
		CSV.open("error_files/year_ranking.csv", "wb") do |csv|
			data.each do |d|
				csv << d
			end
		end		
	end
end
