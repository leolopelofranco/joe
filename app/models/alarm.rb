class Alarm < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :alarms
end
