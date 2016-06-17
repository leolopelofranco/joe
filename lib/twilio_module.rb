module TwilioModule

  require 'sinatra'
  require 'twilio-ruby'

  class << self

    def receive_sms
      post '/receive_sms' do
        content_type 'text/xml'

        response = Twilio::TwiML::Response.new do |r|
          r.Message 'Hey Thanks for Messaging me!'
        end

        response.to_xml
      end
    end

    def send_message(phone_number, body)
      # put your own credentials here
      account_sid = 'ACc615c1db2c1d0f2383d1f26da558a289'
      auth_token = '469c8c6499aabc3df6286218064b6345'

      # set up a client to talk to the Twilio REST API
      @client = Twilio::REST::Client.new account_sid, auth_token

      @client.account.messages.create({
      	:from => '+16502002404',
      	:to => phone_number,
      	:body => body,
      })
    end
  end

end
