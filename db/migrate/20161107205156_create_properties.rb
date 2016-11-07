class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.attachment :photo
      t.integer :loan_type
      t.decimal :purchase_price
      t.decimal :down_payment_pct
      t.decimal :annual_gross_rental_income
      t.integer :stated_residence
      t.integer :actual_residence
      t.references :investor, index: true

      t.timestamps null: false
    end
    add_foreign_key :properties, :investors
  end
end
