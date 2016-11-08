class PropertiesController < ApplicationController
	
	def index
		@properties = Property.all
	end

	def new
		@property = Property.new
	end

	def edit
		@property = Property.find(params[:id])
	end

	def create
		@property = Property.new(property_params)
		if @property.save
			redirect_to action: "index"
		else
			render 'new'
		end
	end

	def update
		@property = Property.find(params[:id])

		if @property.update(property_params)
			redirect_to action: "edit"
		else
			render 'edit'
		end
	end


private
  def property_params
    params.require(:property).permit(:name, :address, :city, :state, :zip, :photo, :loan_type, :purchase_price, :down_payment_pct, 
    	:monthly_gross_rental_income, :stated_residence, :actual_residence, :investor_id, :sell_existing, :omi_unit_rent, :notes, 
    	:number_of_units, :link)
  end
end