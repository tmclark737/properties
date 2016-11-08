class AddColumnToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :omi_unit_rent, :decimal
  end
end
