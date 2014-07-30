require 'csv'
class BseIndicesDump < ActiveRecord::Base
	belongs_to :bse_indices
	validates :date, uniqueness: { scope: :bse_indices_id}

	def self.update_data
		data = CSV.read("/home/trantor/Downloads/bhav_copy/bse_indices/Index.csv")
		data.delete_at(0)
		data.each do |d|
			d = d[0].split("\t")
			BseIndices.create(:indices_name => d[0])			
			id = BseIndices.where("indices_name = ?", d[0]).first.id
			
			data_bid = CSV.read("/home/trantor/Downloads/bhav_copy/bse_indices/" + d[13])
			data_bid.delete_at(0)
			data_bid.each do |dd|
				BseIndicesDump.create(:bse_indices_id => id,
					:date => Date.parse(dd[0]).to_s, :open => dd[1], 
					:high => dd[2], :low => dd[3], :close => dd[4])
			end
		end
	end

	def self.daily_update
		data = CSV.read("/home/trantor/Downloads/bhav_copy/bse_indices/Index.csv")
		data.delete_at(0)
		date = Time.now.strftime("%Y-%m-%d") 
		indices = BseIndices.all
		indices_name = indices.collect(&:indices_name)
		data.each do |d|
			d = d[0].split("\t")
			if indices_name.include?(d[0])
				id = BseIndices.where("indices_name = ?", d[0]).first.id
				BseIndicesDump.create(:bse_indices_id => id,
					:date => date, :open => d[1], 
					:high => d[2], :low => d[3], :close => d[4])
			end
		end
	end
end
