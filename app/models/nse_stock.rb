class NseStock < ActiveRecord::Base
	has_many :nse_stocks_details, dependent: :destroy

	def self.vol_category
		ids = NseStock.all
		ids.each do |stock|
			average = NseStocksDetail.where("nse_stock_id = ?", stock.id).order("date DESC").limit(30).collect(&:volume).sum / 30
			if average > 5000 and average < 10001
				stock.update_attributes(:vol_category => 1)	
			elsif average > 10000 and average < 25001
				stock.update_attributes(:vol_category => 2)
			elsif average > 25000 and average < 100001
				stock.update_attributes(:vol_category => 3)
			elsif average > 100000
				stock.update_attributes(:vol_category => 4)
			end
		end
	end
end
