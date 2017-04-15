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
                  user_id: user.id,
                  stock: medicine["stock"].to_i
                )
    end


    if schedule.start_date.today?
      params[:every_array].each do |every|
        e = every.to_datetime.change(:offset => "+0800")
        if e < Time.now
          alarm = Alarm.create(
                    alarm: e,
                    status: 'open',
                    user_id: user.id,
                    schedule_id: schedule.id
                  )
        end
      end
      UserMailer.send_reminder
    end


    schedule.days = schedule.days.split(",").map(&:to_i)

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
    schedule = Schedule.find(params[:schedule]["schedule_id"])
    user = User.find(schedule.user_id)
    schedule.frequency = params[:schedule]["frequency"]
    schedule.days = params[:schedule]["days"]
    schedule.every = params[:schedule]["every"]
    schedule.start_date = params[:schedule]["start_date"]
    schedule.end_date = params[:schedule]["end_date"]
    schedule.status = params[:schedule]["status"]

    schedule.save!

    params[:medicines].each do |medicine|


      if medicine.key?(:med_count)
        medic = Medicine.create(
                    name: medicine["name"],
                    dosage: medicine["dosage"],
                    schedule_id: schedule.id,
                    user_id: user.id,
                    stock: medicine["stock"]
                  )
      else
        med = Medicine.find(medicine["id"])

        med.name = medicine["name"]
        med.dosage = medicine["dosage"]
        med.schedule_id = schedule.id
        med.user_id = user.id
        med.stock = medicine["stock"]

        med.save!
      end

    end

    schedules = {
      :schedule => schedule,
      :medicines => schedule.medicines
    }

    render json: schedules
  end

  def take
    schedule = Schedule.find(params[:schedule_id])
    alarms = schedule.alarms.search{|x| x.alarm == params[:alarm].to_datetime }
    alarm = alarms[0]
    alarm.status = params[:status]
    alarm.save!

    response = {
      :alarm => alarm
    }

    render json: response
  end


end
