class AddAttributesToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :schedule_id, :integer
    add_column :alarms, :date_taken, :datetime
    add_column :alarms, :user_id, :integer
    add_column :alarms, :alarm, :datetime
    add_column :alarms, :status, :string
  end
end
