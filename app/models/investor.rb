class Investor < ActiveRecord::Base

	has_many :properties

	def total_annual_income
		tys_income = (self.tys_2015_income + self.tys_2016_income)/2.0
		tys_income + self.tracys_income
	end

	def total_monthly_income
		self.total_annual_income/12.0
	end

	def qualified_personal_income
		total_monthly_income * 0.43
	end

	def building_equity
		self.existing_home_value - self.existing_debt
	end

	def maximum_cash_out
		self.maxium_cash_out_loan_amount - self.existing_debt
	end

end



    # t.string   "name"
    # t.decimal  "tys_2015_income"
    # t.decimal  "tys_2016_income"
    # t.decimal  "tracys_income"
    # t.decimal  "existing_home_value"
    # t.decimal  "existing_debt"
    # t.decimal  "checking_savings"
    # t.decimal  "retirement_savings"
    # t.decimal  "maxium_cash_out_loan_amount"