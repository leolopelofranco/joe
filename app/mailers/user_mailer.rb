class UserMailer < ActionMailer::Base
  include TwilioModule, ChikkaModule

  def send_reminder
    globe_numbers = ['905','906','915','916','917','926','927','935','936','937','945','975','976','977','994','995','996','997']
    smart_numbers = ['907','908','909','910','911','912','913','914','918','919','920','921','922','923','924','925','928','929','930','932','933','934','938','939','942','943','946','947','948','949','950','970','981','989','998','999']

    time = Time.zone.now
    alarms=Alarm.all.select{|x| x.status == 'open'}
    Rails.logger.info alarms
    alarms.each do |alarm|
      diff = time - alarm.alarm
      if diff.abs < 600
        Rails.logger.info 'Success'
        current_user = User.find(alarm.user_id)
        phone_number= "63"+ current_user.mobile
        t = alarm.alarm.strftime("%I:%M %P")
        if t.include? 'am'
          period_time = 'morning'
        elsif t.include? '12:00 pm'
          period_time = 'noon'
        else
          period_time = 'evening'
        end

        medicines = Schedule.find(alarm.schedule_id).medicines
        directions = medicines.map { |x| x.direction }
        #mornings

        before_meals = directions.count('Before Meals')
        after_meals = directions.count('After Meals')

        if before_meals != 0 && after_meals != 0
          message = "Hello #{current_user.first_name}! A friendly reminder to take your #{period_time} #{t} medicines. 1 packet before meal and 1 packet after meal."
        elsif before_meals != 0
          message = "Hello #{current_user.first_name}! A friendly reminder to take your #{period_time} #{t} medicines. 1 packet before meal."
        elsif after_meals != 0
          message = "Hello #{current_user.first_name}! A friendly reminder to take your #{period_time} #{t} medicines. 1 packet after meal."
        else
          message = "Hello #{current_user.first_name}! A friendly reminder to take your #{period_time} #{t} medicines."
        end

        message_type = 'SEND'
        request_id = 0

        response = ChikkaModule.send_sms(phone_number, message, message_type, request_id)

        # if globe_numbers.include? current_user.mobile[0,3]
        #   response = SemaphoreModule.send_sms(phone_number, message)
        # else
        #   response = ChikkaModule.send_sms(phone_number, message, message_type, request_id)
        # end

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
    time = Time.zone.now
    scheds=Schedule.all.select{|x| x.status == 'active' && (x.start_date.to_date..x.end_date.to_date).cover?(Time.zone.now.to_date) && (x.days.split(",").map(&:to_i)).include?(time.wday)}

    # create the alarm of the day
    scheds.each do |sched|
      every = sched.every.split(",")
      every.each do |e|
        if e.to_f > 12
          e = Time.zone.parse(e).to_datetime
        else
          e = Time.zone.parse(e).to_datetime + 1.days
        end
        alarm = Alarm.create(
                    alarm: e,
                    status: 'open',
                    user_id: sched.user_id,
                    schedule_id: sched.id
                  )
      end
    end

    scheds_act=Schedule.all.select{|x| x.status == 'active' }

    scheds_act.each do |sched|
      diff = sched.end_date - Time.zone.now

      if diff < 0
        sched.status = 'expired'
        sched.save!
      end
    end
  end
end
