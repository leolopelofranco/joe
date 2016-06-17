module ChikkaModule
  class << self

    def generate_random_code
      return Random.rand(10001..99999).to_s
    end

    def send_sms(phone_number, message)

      message_id = generate_random_code()

      params = Hash.new

      params['message_type'] = "SEND"
      params['mobile_number'] = phone_number
      params['shortcode'] = "29290684"
      params['message_id'] = message_id
      params['message'] = message
      params['client_id'] = "fc83a5280e22fbd48dd04f4b5943c7ff23d031ec396ef23006c9b5b211b55554"
      params['secret_key'] = "231e6202e8fec7b2505244cd8d59a68b0f2b971e3cb39a98ed245267e5087aa3"

      response = Net::HTTP.post_form(URI.parse("https://post.chikka.com/smsapi/request"), params)
    end
  end

end
