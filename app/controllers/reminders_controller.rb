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


end
