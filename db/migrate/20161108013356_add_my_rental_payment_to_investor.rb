class AddMyRentalPaymentToInvestor < ActiveRecord::Migration
  def change
    add_column :investors, :my_rental_payment, :decimal
  end
end
