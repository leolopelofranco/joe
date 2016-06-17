class AddUserIdToMedicines < ActiveRecord::Migration
  def change
    add_column :medicines, :user_id, :integer
  end
end
