class MainController < ApplicationController

	def index
		@st_data_bse = BseBsStrategy.all
		@st_data_nse = NseBsStrategy.all
	end
end
