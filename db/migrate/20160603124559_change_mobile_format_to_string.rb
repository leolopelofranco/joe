class ChangeMobileFormatToString < ActiveRecord::Migration
  def change
    change_column :users, :mobile, :string
  end
end
