require 'open-uri'
require 'csv'
class NseIndicesDump < ActiveRecord::Base
	belongs_to :nse_indices
	validates :date, uniqueness: { scope: :nse_indices_id}

	def self.update_data
		data = CSV.read("/home/trantor/Downloads/bhav_copy/nse_indices/Index.csv")
		data.delete_at(0)
		data.each do |d|
			d = d[0].split("\t")
			NseIndices.create(:indices_name => d[0])			
			id = NseIndices.where("indices_name = ?", d[0]).first.id
			nin = d[0].upcase.gsub(" ", "%20")
			file = open("http://www.nseindia.com/content/indices/histdata/#{nin}01-01-2009-31-07-2014.csv")
			indices_data = file.read	
			indices_data = CSV.parse(indices_data)
			indices_data.delete([])
			indices_data.delete_at(0)
			
			indices_data.each do |dd|
				NseIndicesDump.create(:nse_indices_id => id,
					:date => Date.parse(dd[0]).to_s, :open => dd[1], 
					:high => dd[2], :low => dd[3], :close => dd[4],
					:volume => dd[5])
			end
		end
	end

	def self.daily_update
		daate = Time.now.strftime("%d%m%Y")
		date = Time.now.strftime("%Y-%m-%d") 
		indices = NseIndices.all
		indices_name = indices.collect(&:indices_name)
		file = open("http://www.nseindia.com/content/indices/ind_close_all_#{daate}.csv")
		indices_data = file.read	
		indices_data = CSV.parse(indices_data)
		indices_data.delete([])
		indices_data.delete_at(0)		
		indices_data.each do |dd|
			if indices_name.include?(dd[0])
				id = NseIndices.where("indices_name = ?", dd[0]).first.id
				NseIndicesDump.create(:nse_indices_id => id,
					:date => date, :open => dd[2], 
					:high => dd[3], :low => dd[4], :close => dd[5],
					:volume => dd[5])
			end
		end		
	end
end
