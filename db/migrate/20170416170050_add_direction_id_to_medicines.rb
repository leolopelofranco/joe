class AddDirectionIdToMedicines < ActiveRecord::Migration
  def change
    add_column :medicines, :direction, :string
  end
end
