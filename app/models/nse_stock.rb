class NseStock < ActiveRecord::Base
	has_many :nse_stocks_details, dependent: :destroy
	has_one :nse4_trends, dependent: :destroy
	has_one :nse3_trends, dependent: :destroy
	has_one :nse2_trends, dependent: :destroy
	has_one :nse1_trends, dependent: :destroy

	def self.vol_category
		ids = NseStock.all
		ids.each do |stock|
			data = NseStocksDetail.where("nse_stock_id = ?", stock.id).order("date DESC").limit(30).collect(&:volume).sum / 30
			avg_vol = data.collect(&:volume).sum / 200
			if avg_vol > 5000 and avg_vol < 10001
				stock.update_attributes(:vol_category => 1)	
			elsif avg_vol > 10000 and avg_vol < 25001
				stock.update_attributes(:vol_category => 2)
			elsif avg_vol > 25000 and avg_vol < 100001
				stock.update_attributes(:vol_category => 3)
			elsif avg_vol > 100000
				stock.update_attributes(:vol_category => 4)
			end
			
			avg_price = data.collect(&:close).sum / 200
			if avg_price > 30 and avg_price < 101
				stock.update_attributes(:price_category => 1)	
			elsif avg_price > 100 and avg_price < 401
				stock.update_attributes(:price_category => 2)
			elsif avg_price > 400 and avg_price < 1001
				stock.update_attributes(:price_category => 3)
			elsif avg_price > 1000
				stock.update_attributes(:price_category => 4)
			end
		end
	end
end
