class MessagesController < ApplicationController
  include ChikkaModule

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!, :only => [:receive_sms, :palm_sms, :get_s3_upload_key]


  def palm_patsy_pink
    mobile = params[:mobile]
    message = params[:message]
    message_type = 'SEND'
    request_id = 0
    x = ChikkaModule.send_sms(mobile, message, message_type, request_id)


    render json: {
      result: x,
      status: 'success'
    }
  end

  def palm_sms
    phone_number = 639175314928
    email = params[:email]
    mobile = params[:mobile]
    note = params[:note]
    name = params[:name]
    message_type = 'SEND'
    request_id = 0

    message = "#{name} just inquired on Palm. Contact details are #{email} and #{mobile}. He said #{note}."

    x = ChikkaModule.send_sms(phone_number, message, message_type, request_id)


    render json: {
      result: x,
      status: 'success'
    }
  end

  def palm_code
    mobile = params[:mobile]
    name = params[:name]
    code = params[:code]
    message_type = 'SEND'
    request_id = 0

    message = "Hi #{name}, your verification code is #{code}."

    x = ChikkaModule.send_sms(mobile, message, message_type, request_id)


    render json: {
      result: x,
      status: 'success'
    }
  end

  def palm_honeypot
    phone_number = params[:mobile]
    brand = params[:brands]
    message_type = 'SEND'
    request_id = 0
    message = ""
    Rails.logger.info params[:brands]
    params[:brands].each do |brand|
      unless brand["links"].nil?
        posts = ""
        brand["links"].each do |link|
          posts = posts + ' ' +  link["link"] +' with ' + link["engagements"].to_s + ' engagements. '
        end
        message  = message + ' ' + brand["brand"] + " has brewing campaigns. They are " + posts
      end
    end

    x = ChikkaModule.send_sms(phone_number, message, message_type, request_id)


    render json: {
      result: x,
      status: 'success'
    }
  end

  def palm_motolite
    phone_number = 639175314928
    message_type = 'SEND'
    request_id = 0
    message = "Hi Motolite! Leo wants to talk to a Customer Rep. Check it here at https://m.me/motoliteexpresshatid"

    x = ChikkaModule.send_sms(phone_number, message, message_type, request_id)


    render json: {
      result: x,
      status: 'success'
    }
  end

  def palm_inquiries
    phone_number = params[:mobile]
    company = params[:company]
    name = params[:name]
    link = params[:link]
    message_type = 'SEND'
    request_id = 0
    message = "Hi #{company}! #{name} wants to talk to a Customer Rep. Check it here at #{link}"

    x = ChikkaModule.send_sms(phone_number, message, message_type, request_id)


    render json: {
      result: x,
      status: 'success'
    }
  end

  def palm_patsy
    phone_number = params[:branch]
    first_name = params[:first_name]
    last_name = params[:last_name]
    mobile = params[:mobile]
    date = params[:date]
    time = params[:time]
    table = params[:table]
    comment = params[:comment]
    message_type = 'SEND'
    request_id = 0

    message = "Hi, #{first_name} #{last_name} just a made reservation for #{table} at #{date}, #{time}. Contact him/her at #{mobile}. Some comments are #{comment}. Ty"

    x = ChikkaModule.send_sms(phone_number, message, message_type, request_id)


    render json: {
      result: x,
      status: 'success'
    }
  end

  def get_s3_upload_key

    require 'base64'
    require 'openssl'
    require 'digest/sha1'

    bucket = 'sigv4examplebucket'
    access_key = 'AKIAIOSFODNN7EXAMPLE'
    secret = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
    key = "user/user1/"
    expiration = 5.minutes.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    max_filesize = 2.megabytes
    acl = 'public-read'
    sas = '201' # Tells amazon to redirect after success instead of returning xml
    policy = Base64.encode64(
      "{ 'expiration': '2015-12-30T12:00:00.000Z',
        'conditions': [
          {'bucket': 'sigv4examplebucket'},
          ['starts-with', '$key', 'user/user1/'],
          {'acl': 'public-read'},
          {'success_action_redirect': 'http://sigv4examplebucket.s3.amazonaws.com/successful_upload.html'},
          ['starts-with', '$Content-Type', 'image/'],
          {'x-amz-meta-uuid': '14365123651274'},
          {'x-amz-server-side-encryption': 'AES256'},
          ['starts-with', '$x-amz-meta-tag', ''],

          {'x-amz-credential': 'AKIAIOSFODNN7EXAMPLE/20151229/us-east-1/s3/aws4_request'},
          {'x-amz-algorithm': 'AWS4-HMAC-SHA256'},
          {'x-amz-date': '20151229T000000Z' }
        ]
      }
      ").gsub(/\n|\r/, '')
    signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('SHA256'), secret, policy)).gsub(/\n| |\r/, '')
    hello = {:access_key => access_key, :key => key, :policy => policy, :signature => signature, :sas => sas, :bucket => bucket, :acl => acl, :expiration => expiration}

    render json: {
      result: signature,
      status: 'success',
      hello: hello,
      policy: policy
    }
  end

  def receive_sms

    if params['message_type'] = 'INCOMING' || params['message_type'] = 'incoming'

      reply_message = params['message']

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
          ChikkaModule.send_sms('+639175314928', reply_message, 'SEND', 0)

        end
      end
      # else
      #   phone_number = params['mobile_number']
      #   message = 'Wrong Keyword. Reply YES if taken. If not, feel free to ignore this message.'
      #   message_type = 'SEND'
      #   request_id = 0
      #
      #   Rails.logger.info phone_number
      #   Rails.logger.info message
      #   Rails.logger.info message_type
      #   Rails.logger.info request_id
      #
      #   ChikkaModule.send_sms(phone_number, message, message_type, request_id)
      # end


    end

    render json: {
      status: 'success'
    }
  end
end
