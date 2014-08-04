class NseStock < ActiveRecord::Base
	has_many :nse_stocks_details, dependent: :destroy
	has_many :nse_dumps, dependent: :destroy
	# has_one :nse4_trends, dependent: :destroy
	# has_one :nse3_trends, dependent: :destroy
	# has_one :nse2_trends, dependent: :destroy
	# has_one :nse1_trends, dependent: :destroy
	has_one :nse_trends, dependent: :destroy
	has_many :nse_bs_strategies, dependent: :destroy

	def self.category
		ids = NseStock.all
		dates = NseDump.uniq.pluck(:date).reverse[0..30].sort
		datas = NseDump.where("date between ? and ?", dates.first, dates.last)
		ids.each do |stock|
			avg_vol = []			
			data = datas.where("nse_stock_id = ?", stock.id)
			if data.nil? || data.count < 29
				stock.update_attributes(:vol_category => -1, :price_category => -1)
			else
				avg_vol << data.collect(&:volume).find_all{|i| i < 5000}.count
				avg_vol << data.collect(&:volume).find_all{|i| i > 5000 and i < 10001}.count
				avg_vol << data.collect(&:volume).find_all{|i| i > 10000 and i < 25001}.count
				avg_vol << data.collect(&:volume).find_all{|i| i > 25000 and i < 100001}.count
				avg_vol << data.collect(&:volume).find_all{|i| i > 100000 and i < 5000001}.count
				avg_vol << data.collect(&:volume).find_all{|i| i > 5000000}.count
				vc = (avg_vol.index(avg_vol.max))
				pc = 0
				avg_price = data.collect(&:close).sum / data.count
				if avg_price > 30 and avg_price < 101
					pc = 1	
				elsif avg_price > 100 and avg_price < 401
					pc = 2
				elsif avg_price > 400 and avg_price < 1001
					pc = 3
				elsif avg_price > 1000
					pc = 4
				end
				avg_turnover = data.where("date > '2014-07-11'").collect(&:turnover)
				avg_turnover1 = data.where("date <= '2014-07-11'").collect(&:turnover)
				avg_turnover = avg_turnover.sum / (100000 * avg_turnover.count)
				avg_turnover1 = avg_turnover1.sum / avg_turnover1.count
				avg_turnover = avg_turnover + avg_turnover1
				
				stock.update_attributes(:vol_category => vc, :price_category => pc, :useless_stock => 1) if avg_turnover > 10
				stock.update_attributes(:vol_category => vc, :price_category => pc, :useless_stock => -1) if avg_turnover <= 10
			end
		end
	end
end
