class PatientsController < ApplicationController
  def index
  end

  def list
    list = []
    users = User.all

    users.each do |user|
      status = 'inactive'
      if User.find(user.id).schedules.map { |x| x.status}.include? 'active'
        status = 'active'
      end

      list << {
        user_id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        mobile: user.mobile,
        schedules: user.schedules.count,
        medicines: user.medicines.count,
        status: status
      }
    end
      render json: list
  end

  def get_patient
    user = User.find(params[:patient_id])
    schedules = user.schedules
    schedule  = []

    schedules.each do |sched|
      sched.days = sched.days.split(",").map(&:to_i)

      schedule << {
        created_at: sched.created_at,
        updated_at: sched.updated_at,
        user_id: sched.user_id,
        days: sched.days,
        frequency: sched.frequency,
        start_date: sched.start_date,
        end_date: sched.end_date,
        every: sched.every,
        status: sched.status,
        medicines: sched.medicines
      }
    end
    response = {
      :user => user,
      :schedules => schedule
    }

    render json: response
  end

  def get_schedule
    user = User.find(params[:patient_id])
    schedule = Schedule.find(params[:schedule_id])
    schedule.days = schedule.days.split(",").map(&:to_i)
    medicines = schedule.medicines

    sched = {
      created_at: schedule.created_at,
      updated_at: schedule.updated_at,
      user_id: schedule.user_id,
      days: schedule.days,
      frequency: schedule.frequency,
      start_date: schedule.start_date,
      end_date: schedule.end_date,
      every: schedule.every,
      status: schedule.status,
      medicines: schedule.medicines
    }

    response = {
      :user => user,
      :schedule => sched,
      :medicines => medicines
    }

    render json: response
  end
end
