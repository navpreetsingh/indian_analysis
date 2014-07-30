class NseIndices < ActiveRecord::Base
	has_many :nse_indices_dumps, dependent: :destroy
	validates_uniqueness_of :indices_name
end
