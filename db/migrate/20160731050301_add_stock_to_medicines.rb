class AddStockToMedicines < ActiveRecord::Migration
  def change
    add_column :medicines, :stock, :integer
  end
end
