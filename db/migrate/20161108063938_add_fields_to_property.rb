class AddFieldsToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :notes, :text
    add_column :properties, :number_of_units, :integer
    add_column :properties, :link, :string
  end
end
