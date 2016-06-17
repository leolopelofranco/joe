class AddAttributesToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :user_id, :integer
    add_column :schedules, :days, :string
    add_column :schedules, :frequency, :integer
    add_column :schedules, :start_date, :datetime
    add_column :schedules, :end_date, :datetime
    add_column :schedules, :every, :string
    add_column :schedules, :status, :string
  end
end
