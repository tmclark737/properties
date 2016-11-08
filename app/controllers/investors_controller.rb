class InvestorsController < ApplicationController

	def index
		@investors = Investor.all
	end
	
	def edit
		@investor = Investor.find(params[:id])
	end

	def update
		# console
		@investor = Investor.find(params[:id])

		if @investor.update(investor_params)
			redirect_to action: "index"
		else
			render 'edit'
		end
	end

private
  def investor_params
    params.require(:investor).permit(:name, :tys_2015_income, :tys_2016_income, :tracys_income, :existing_home_value, 
    	:existing_debt, :checking_savings, :retirement_savings, :maxium_cash_out_loan_amount, :my_rental_payment)
  end
end

