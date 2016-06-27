class MessagesController < ApplicationController
  include ChikkaModule

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!, :only => "receive_sms"

  def receive_sms

    if params['message_type'] = 'INCOMING' || params['message_type'] = 'incoming'

      if params['message'].strip.upcase == 'YES'

        users = User.all.select{|x| x.mobile == params['mobile_number'][2..-1] }

        users.each do |user|
          alarms = user.alarms.select{|x| x.status == 'sent' }
          unless alarms.empty?
            time = Time.now.to_i
            alarm_taken = alarms.sort_by{ |x| "ABS(x.alarm.to_i - time)"}.first
            alarm_taken.status = 'taken'
            alarm_taken.save!

            phone_number = params['mobile_number']
            message = 'Thank you. Response noted.'
            message_type = 'REPLY'
            request_id = params['request_id']

            Rails.logger.info phone_number
            Rails.logger.info message
            Rails.logger.info message_type
            Rails.logger.info request_id

            ChikkaModule.send_sms(phone_number, message, message_type, request_id)


          end
        end
      else
        phone_number = params['mobile_number']
        message = 'Wrong Keyword. Reply YES if taken. If not, feel free to ignore this message.'
        message_type = 'SEND'
        request_id = 0

        Rails.logger.info phone_number
        Rails.logger.info message
        Rails.logger.info message_type
        Rails.logger.info request_id

        ChikkaModule.send_sms(phone_number, message, message_type, request_id)
      end


    end

    render json: {
      status: 'success'
    }
  end
end
