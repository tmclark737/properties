class CreateInvestors < ActiveRecord::Migration
  def change
    create_table :investors do |t|
      t.string :name
      t.decimal :tys_2015_income
      t.decimal :tys_2016_income
      t.decimal :tracys_income
      t.decimal :existing_home_value
      t.decimal :existing_debt
      t.decimal :checking_savings
      t.decimal :retirement_savings
      t.decimal :maxium_cash_out_loan_amount

      t.timestamps null: false
    end
  end
end
