class HomeController < ApplicationController



  skip_before_filter :verify_authenticity_token

  def index
  end

  def detect
    text = params[:text]
    Rails.logger.info text

    language = text.language

    render json: {
      result: language,
      status: 'success'
    }

  end

  def inquire
    inquiry = {}
    inquiry["name"] = params[:name]
    inquiry["from"] = params[:from]
    inquiry["to"] = params[:to]
    inquiry["number"] = params[:number]
    inquiry["message"] = params[:message]
    inquiry["subject"] = params[:subject]

    UserNotifier.welcome_email(inquiry).deliver
    render json: {
      status: 'success'
    }
  end

  def reserve
    inquiry = {}
    inquiry["name"] = params[:name]
    inquiry["class"] = params[:class]
    inquiry["from"] = params[:from]
    inquiry["to"] = params[:to]
    inquiry["number"] = params[:number]
    inquiry["message"] = params[:message]
    inquiry["date"] = params[:date]
    inquiry["time"] = params[:time]
    inquiry["subject"] = params[:subject]

    UserNotifier.reservation_email(inquiry).deliver
    render json: {
      status: 'success'
    }
  end
end
