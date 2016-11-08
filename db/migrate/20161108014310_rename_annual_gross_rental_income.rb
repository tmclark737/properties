class RenameAnnualGrossRentalIncome < ActiveRecord::Migration
  def change
  	rename_column :properties, :annual_gross_rental_income, :monthly_gross_rental_income
  end
end
