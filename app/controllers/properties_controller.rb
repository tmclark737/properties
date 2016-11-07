class PropertiesController < ApplicationController
	
	def index
		@properties = Property.all
	end

	def edit
		@property = Property.find(params[:id])
	end

	def update
		@property = Property.find(params[:id])

		if @property.update(property_params)
			redirect_to action: "index"
		else
			render 'edit'
		end
	end


private
  def property_params
    params.require(:property).permit(:name, :address, :city, :state, :zip, :photo, :loan_type, :purchase_price, :down_payment_pct, 
    	:annual_gross_rental_income, :stated_residence, :actual_residence, :investor_id)
  end
end