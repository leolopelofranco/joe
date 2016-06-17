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
      schedule << {
        schedule: sched,
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
    medicines = schedule.medicines
    response = {
      :user => user,
      :schedule => schedule,
      :medicines => medicines
    }

    render json: response
  end
end
