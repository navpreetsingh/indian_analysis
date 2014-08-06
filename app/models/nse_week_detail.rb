require 'csv'
class NseWeekDetail < ActiveRecord::Base

	def self.ranking
		week_dates = NseWeekDetail.uniq.pluck(:date1).sort[-7..-1].reverse
		month_dates = NseMonthDetail.uniq.pluck(:date1).sort[-4..-1].reverse
		top_stocks = NseWeekDetail.where("date1 = ?", week_dates[0]).order("oc_diff desc").limit(200)

	end
end
