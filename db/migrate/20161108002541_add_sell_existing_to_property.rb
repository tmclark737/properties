class AddSellExistingToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :sell_existing, :integer
  end
end
