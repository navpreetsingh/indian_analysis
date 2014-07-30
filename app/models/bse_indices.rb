class BseIndices < ActiveRecord::Base
	has_many :bse_indices_dumps, dependent: :destroy
	validates_uniqueness_of :indices_name
end
