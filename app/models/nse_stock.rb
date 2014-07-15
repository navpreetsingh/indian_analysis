class NseStock < ActiveRecord::Base
	has_many :nse_stocks_details, dependent: :destroy
	# has_one :nse4_trends, dependent: :destroy
	# has_one :nse3_trends, dependent: :destroy
	# has_one :nse2_trends, dependent: :destroy
	# has_one :nse1_trends, dependent: :destroy
	has_one :nse_trends, dependent: :destroy
	has_many :nse_bs_strategies, dependent: :destroy

	def self.vol_category
		ids = NseStock.all
		ids.each do |stock|
			avg_vol = []
			data = NseStocksDetail.where("nse_stock_id = ?", stock.id).order("date DESC").limit(30)
			avg_vol << data.collect(&:volume).find_all{|i| i > 5000 and i < 10001}.count
			avg_vol << data.collect(&:volume).find_all{|i| i > 10000 and i < 25001}.count
			avg_vol << data.collect(&:volume).find_all{|i| i > 25000 and i < 100001}.count
			avg_vol << data.collect(&:volume).find_all{|i| i > 100000 and i < 5000001}.count
			avg_vol << data.collect(&:volume).find_all{|i| i > 5000000}.count
			stock.update_attributes(:vol_category => avg_vol.index(avg_vol.max) + 1)
			
			
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
