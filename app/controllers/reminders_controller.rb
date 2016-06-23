class RemindersController < ApplicationController
  include ChikkaModule

  def index
  end

  def create
    alarms = []

    user = User.find(params[:user_id])

    schedule = Schedule.create(
                user_id: user.id,
                days: params[:days],
                frequency: params[:frequency],
                start_date: params[:start_date].to_datetime,
                end_date: params[:end_date].to_datetime,
                every: params[:every],
                status: 'active',
              )

    params[:medicines].each do |medicine|
      med = Medicine.create(
                  name: medicine["name"],
                  dosage: medicine["dosage"],
                  schedule_id: schedule.id,
                  user_id: user.id
                )
    end


    if schedule.start_date.today?
      params[:every_array].each do |every|
        e = every.to_datetime.change(:offset => "+0800")
        if e > Time.now
          alarm = Alarm.create(
                    alarm: e,
                    status: 'open',
                    user_id: user.id,
                    schedule_id: schedule.id
                  )
        end
      end
    end

    # Filter schedule.all if scheudle.status is active and if date now is within daterange
    #
    # 8am 12 pm 3pm 5pm 6pm 7pm
    #
    # which time is the closest to datenow
    #
    # return schedule

    # params[:alerts].each do |alert|
    #   alarm = Alarm.create(
    #             alarm: alert['time'], #datetime
    #             status: ,
    #             user_id: user.id,
    #             schedule_id: params[:schedule_id]
    #           )
    #   alarms << alarm
    # end

    reminder = {
      :user => user,
      :schedule => schedule
    }

    render json: reminder
  end

  def set
    require 'active_support'


    to_be_sorted = []
    time = Time.new
    scheds=Schedule.all.select{|x| x.status == 'active' && (x.start_date..x.end_date).cover?(Time.now) && (x.days.split(",").map(&:to_i)).include?(time.wday)}
    total_time = (time.hour*3600) + (time.min*60)

    render json: scheds
  end

  def edit
    user = User.find(params[:patient_id])
    schedule = Schedule.find(params[:schedule_id])

    user.first_name = params[:reminder]["first_name"]
    user.last_name = params[:reminder]["last_name"]
    user.mobile = params[:reminder]["mobile"]
    user.email = params[:reminder]["mobile"]

    schedule.frequency = params[:reminder]["frequency"]
    schedule.days = params[:reminder]["days"]
    schedule.every = params[:reminder]["every"]
    schedule.start_date = params[:reminder]["start_date"]
    schedule.end_date = params[:reminder]["end_date"]
    schedule.status = params[:reminder]["status"]

    user.save!
    schedule.save!

    reminder = {
      :user => user,
      :schedule => schedule,
    }

    render json: reminder
  end


  def receive_sms

    Rails.logger.info 'seeee'
    if params['message_type'] = 'INCOMING'
      response = {
        :message => params['message'],
        :mobile_number => params['mobile_number'],
        :shortcode => params['shortcode'],
        :timestamp => params['timestamp'],
        :request_id => params['request_id']
      }

      if params['message'] == 'YES'

        users = User.all.select{|x| x.mobile == params['mobile_number'] }

        users.each do |user|
          alarms = user.alarms.select{|x| x.status == 'sent' }
          unless alarms.empty?
            time = Time.now.to_i
            alarm_taken = alarms.sort_by{ |x| "ABS(x.alarm.to_i - time)"}.first
            Rails.logger.info alarm_taken
            alarm_taken.status = 'taken'
            alarm_taken.save!

            phone_number = params['mobile_number']
            message = 'Thank you. Response noted.'
            message_type = 'REPLY'

            ChikkaModule.send_sms(phone_number, message, message_type)
          end
        end
      else
        phone_number = params['mobile_number']
        message = 'Wrong Keyword. Reply YES if taken. If not, feel free to ignore this message.'
        message_type = 'REPLY'

        ChikkaModule.send_sms(phone_number, message, message_type)
      end
    end

    render json: {
      status: 'success'
    }
  end

end
