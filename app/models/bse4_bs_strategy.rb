class Bse4BsStrategy < ActiveRecord::Base
	belongs_to :bse_stock

	def self.strategy1
		dates = dates = Bse4pTrend.uniq.pluck(:date).sort
		for i in 0..dates.count - 2
			
		end
	end

	def self.strategy2
		
	end

	def self.strategy3
		
	end
end
