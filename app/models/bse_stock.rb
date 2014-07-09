class BseStock < ActiveRecord::Base
	has_many :bse_stocks_details, dependent: :destroy
	has_one :bse4_trends, dependent: :destroy
	has_one :bse3_trends, dependent: :destroy
	has_one :bse2_trends, dependent: :destroy
	has_one :bse1_trends, dependent: :destroy
	has_many :bse4_bs_strategies, dependent: :destroy
	has_many :bse4p_trends, dependent: :destroy

	def self.category
		ids = BseStock.all
		ids.each do |stock|
			data = BseStocksDetail.where("bse_stock_id = ?", stock.id).order("date DESC").limit(200).collect(&:volume).sum / 30
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
