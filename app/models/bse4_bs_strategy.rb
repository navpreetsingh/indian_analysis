class Bse4BsStrategy < ActiveRecord::Base
	belongs_to :bse_stock

	def self.strategy1
		dates = Bse4pTrend.where("bse_stock_id = 5").collect(&:date).sort
		#For best buyers
		dates.each do |date|
			data = Bse4pTrend.where("date = ? AND d3_t = 3", date).order("avg_high desc").limit(10)
			for st in 1..10
				
			end
		end
	end

	def self.strategy2
		
	end

	def self.strategy3
		
	end
end
