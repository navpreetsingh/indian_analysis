class NseStocksDetail < ActiveRecord::Base
	belongs_to :nse_stock

	def self.bs
		ids = NseStock.all
		ids.each do |stock|
			data = NseStocksDetail.where("nse_stock_id = ?", stock.id).order("date DESC").limit(100)
			for i in 0..data.count - 2
				dt = data[i]
				dy = data[i+1]
				dt_oh = (((dt.high - dt.open) / dt.open)*100).round(2).to_f
				dt_ol = (((dt.low - dt.open) / dt.open)*100).round(2).to_f
				dt_oc = (((dt.close - dt.open) / dt.open)*100).round(2).to_f
				bs = dt_oc > 0 ? 1 : -1
				dy_ch = (((dt.high - dy.close) / dy.close)*100).round(2).to_f
				dy_cl = (((dt.low - dy.close) / dy.close)*100).round(2).to_f
				dy_cc = (((dt.close - dy.close) / dy.close)*100).round(2).to_f
				dt.update_attributes(:bs_signal => bs, :oh_diff => dt_oh, :ol_diff => dt_ol,
					:oc_diff => dt_oc, :ch_diff => dy_ch, :cl_diff => dy_cl, :cc_diff => dy_cc)
			end
		end
	end
end
