class BseStock < ActiveRecord::Base
	has_many :bse_stocks_details, dependent: :destroy
	has_one :bse4_trends, dependent: :destroy
	has_one :bse3_trends, dependent: :destroy
	has_one :bse2_trends, dependent: :destroy
	has_one :bse1_trends, dependent: :destroy

	def self.vol_category
		ids = BseStock.all.collect(&:id)
		ids.each do |stock|
			average = BseStocksDetail.where("bse_stock_id = ?", stock).order("date DESC").limit(30).collect(&:volume).sum / 30
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
