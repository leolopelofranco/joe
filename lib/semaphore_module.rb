module SemaphoreModule
  class << self

    def generate_random_code
      return Random.rand(10001..99999).to_s
    end

    def send_sms(phone_number, message)
      params = Hash.new

      params['apikey'] = 'Jaxn19qGX11Uzm9dxzpJ'
      params['number'] = phone_number
      params['message'] = message
      params['sendername'] = 'W&R'
      params['message_id'] = generate_random_code()

      response = Net::HTTP.post_form(URI.parse("https://api.semaphore.co/api/v4/messages"), params)

    end

    def send_sms2(phone_number, message)
      require 'net/http'
      require 'uri'

      apikey="Jaxn19qGX11Uzm9dxzpJ"
      uri = URI.parse("https://semaphore.co/api/v4/messages")
      request = Net::HTTP::Post.new(uri)
      message = 'hello'
      phone_number='09175314928'
      request.body = "apikey=" + apikey + "&number=" + phone_number + "&message=" + message


      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    end

  end
end
