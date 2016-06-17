class User < ActiveRecord::Base
  has_many :schedules
  has_many :medicines
  has_many :alarms
end
