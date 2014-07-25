class StrategyAnalysis < ActiveRecord::Base
	def self.analysis
		data = Bse4BsStrategy.all
		for i in 1..4
			for j in 1..6
				d = data.where("bs_signal = 1 and strategy = ?", (i*10) + j)
				total = d.count
				if total > 0
					pl = d.collect(&:profit_loss).sum
					ps = d.where("profit_loss > 0").count
					p = (d.where("profit_loss > 0").collect(&:profit_loss).sum).round(2).to_f
					ls = d.where("profit_loss < 0").count
					l = (d.where("profit_loss < 0").collect(&:profit_loss).sum).round(2).to_f
					inv = d.count * 10000 
					ror = ((pl / inv) * 100).round(2).to_f || 0
					StrategyAnalysis.create(:strategy => (i*10) + j, :bs_signal => 1,
						:total_shares => total, :profit_loss => pl, :profit_shares => ps,
						:profit => p, :loss_shares => ls, :loss => l, :investment => inv,
						:ror => ror)
				end
			end
		end

		for i in 1..4
			for j in 1..6
				d = data.where("bs_signal = -1 and strategy = ?", i)
				total = d.count
				if total > 0
					pl = d.collect(&:profit_loss).sum
					ps = d.where("profit_loss > 0").count
					p = (d.where("profit_loss > 0").collect(&:profit_loss).sum).round(2).to_f
					ls = d.where("profit_loss < 0").count
					l = (d.where("profit_loss < 0").collect(&:profit_loss).sum).round(2).to_f
					inv = d.count * 10000
					ror = ((pl / inv) * 100).round(2).to_f
					StrategyAnalysis.create(:strategy => (i*10) + j, :bs_signal => -1,
						:total_shares => total, :profit_loss => pl, :profit_shares => ps,
						:profit => p, :loss_shares => ls, :loss => l, :investment => inv,
						:ror => ror)
				end
			end
		end

	end
end
