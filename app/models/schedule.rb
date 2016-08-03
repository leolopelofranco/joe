class Schedule < ActiveRecord::Base
  has_many :medicines
  has_many :alarms
  belongs_to :user
end
