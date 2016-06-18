class UserMailer < ActionMailer::Base
  include TwilioModule, ChikkaModule

  def send_reminder
    time = Time.now
    alarms=Alarm.all.select{|x| x.status == 'open'}
    alarms.each do |alarm|
      diff = time - alarm.alarm
      if diff.abs < 600
        Rails.logger.info 'Success'
        current_user = User.find(alarm.user_id)
        phone_number= current_user.mobile
        t = alarm.alarm.strftime("%I:%M %P")
        message = "Hello #{current_user.first_name}! Time to take your #{t} meds. Reply YES if taken."
        message_type = 'SEND'
        response = ChikkaModule.send_sms(phone_number, message, message_type)

        # TwilioModule.send_message(phone_number, message)
        alarm.status = "sent"
        alarm.save!
      end
    end

    alarms=Alarm.all.select{|x| x.status == 'sent'}
    alarms.each do |alarm|
      diff = time - alarm.alarm
      if diff > 21600
        alarm.status = 'missed'
        alarm.save!
      end
    end
  end

  def create_alarm_of_the_day
    time = Time.now
    scheds=Schedule.all.select{|x| x.status == 'active' && (x.start_date.to_date..x.end_date.to_date).cover?(Date.today) && (x.days.split(",").map(&:to_i)).include?(time.wday)}

    # create the alarm of the day
    scheds.each do |sched|
      every = sched.every.split(",")
      every.each do |e|
        alarm = Alarm.create(
                    alarm: e.to_datetime.change(:offset => "+0800"),
                    status: 'open',
                    user_id: sched.user_id,
                    schedule_id: sched.id
                  )
      end
    end
  end
end
