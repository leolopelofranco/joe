class Medicine < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :users
end
