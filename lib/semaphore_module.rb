module SemaphoreModule
  class << self

    def generate_random_code
      return Random.rand(10001..99999).to_s
    end

    def send_sms(phone_number, message)
      params = Hash.new

      params['api'] = 'cuY5esrzkyxgpMzYkyvH'
      params['number'] = phone_number
      params['message'] = message
      params['message_id'] = generate_random_code()

      response = Net::HTTP.post_form(URI.parse("http://www.semaphore.co/api/sms"), params)

    end

  end
end
