
class BseStock < ActiveRecord::Base
	has_many :bse_stocks_details, dependent: :destroy
	has_many :bse_dumps, dependent: :destroy
	# has_one :bse4_trends, dependent: :destroy
	# has_one :bse3_trends, dependent: :destroy
	# has_one :bse2_trends, dependent: :destroy
	# has_one :bse1_trends, dependent: :destroy
	has_many :bse_bs_strategies, dependent: :destroy
	has_one :bse_trends, dependent: :destroy
	has_many :bse_best_strategies, dependent: :destroy

	validates_uniqueness_of :stock_name
	validates_uniqueness_of :bse_code

	def self.category
		ids = BseStock.all
		dates = BseDump.uniq.pluck(:date).reverse[0..30].sort
		datas = BseDump.where("date between ? and ?", dates.first, dates.last)			
		ids.each do |stock|
			avg_vol = []
			data = datas.where("bse_stock_id = ?", stock.id)
			if data.nil? or data.count < 29
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
				stock.update_attributes(:vol_category => vc, :price_category => pc)
			end
		end
	end	

	# def self.bse_code
	# 	data = CSV.read("/home/trantor/Downloads/bhav_copy/bse_bhav_copy.csv")
	# 	data.delete_at(0)
	# 	stocks = BseStock.all
	# 	s_names = stocks.where("bse_code = 0").collect(&:stock_name)
	# 	data.each do |dt|
	# 		if s_names.include?(dt[1])
	# 			detail = stocks.find_by_stock_name(dt[1])
	# 			detail.update_attributes(:bse_code => dt[0]) 
	# 		end
	# 	end
	# end
end
