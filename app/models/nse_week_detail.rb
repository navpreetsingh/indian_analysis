require 'csv'
class NseWeekDetail < ActiveRecord::Base

	def self.ranking
		week_dates = NseWeekDetail.uniq.pluck(:date1).sort[-7..-1].reverse
		month_dates = NseMonthDetail.uniq.pluck(:date1).sort[-4..-1].reverse
		top_stocks = NseWeekDetail.find_by_sql("SELECT n1.nse_stock_id, n1.oc_diff, n2.stock_name 
			FROM `nse_week_details` n1 left join nse_stocks n2 on n2.id = n1.nse_stock_id 
			where n1.date1 = '#{week_dates[0]}' order by n1.oc_diff desc").first(200)
		
		week_dates.delete_at(0)	
		data = [["Rank", "Top Stocks", "Profit %"]]
		wdata = []
		mdata = []		
		wids = []
		mids = []		

		week_dates.each do |wd|
			dd = NseWeekDetail.where("date1 = ?", wd).first.date
			data[0] << "#{dd} rank"
			data[0] << "Profit %"
			wdata << NseWeekDetail.find_by_sql("SELECT nse_stock_id, oc_diff FROM `nse_week_details`
				where date1 = '#{wd}' order by oc_diff desc")
			wids << wdata.last.collect(&:nse_stock_id)
		end
		
		month_dates.each do |md|
			dd = NseMonthDetail.where("date1 = ?", md).first.date
			data[0] << "#{dd} rank"
			data[0] << "Profit %"
			mdata << NseMonthDetail.find_by_sql("SELECT nse_stock_id, oc_diff FROM `nse_month_details`
				where date1 = '#{md}' order by oc_diff desc")
			mids << mdata.last.collect(&:nse_stock_id)
		end

		data[0] << "Year: 2014 rank"
		data[0] << "Profit %"
		ydata = NseYearDetail.find_by_sql("SELECT nse_stock_id, oc_diff FROM `nse_year_details`
				where year = 2014 order by oc_diff desc")
		yids = ydata.collect(&:nse_stock_id)

		rank = 1		
		top_stocks.each do |ts|
			data << [rank, ts.stock_name, ts.oc_diff]
			for i in 0..5				
				rr = wids[i].index(ts.nse_stock_id) + 1
				data[rank] <<  rr
				data[rank] << wdata[i][rr - 1].oc_diff
			end
			for i in 0..3
				rr = mids[i].index(ts.nse_stock_id) + 1
				data[rank] <<  rr
				data[rank] << mdata[i][rr - 1].oc_diff
			end
			rr = yids.index(ts.nse_stock_id) + 1
			data[rank] <<  rr
			data[rank] << ydata[rr - 1].oc_diff

			rank += 1
		end

		CSV.open("error_files/week_ranking.csv", "wb") do |csv|
			data.each do |d|
				csv << d
			end
		end	
	end
end
