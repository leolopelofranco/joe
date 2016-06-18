class AddAttributesToMedicines < ActiveRecord::Migration
  def change
    add_column :medicines, :name, :string
    add_column :medicines, :dosage, :string
    add_column :medicines, :schedule_id, :integer
  end
end
