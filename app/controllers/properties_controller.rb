class PropertiesController < ApplicationController
	
	def index
		@properties = Properties.all
	end

	def edit
	end
end