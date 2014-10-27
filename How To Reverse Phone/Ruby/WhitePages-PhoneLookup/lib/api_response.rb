# This class handles for api request and response.
class ApiResponse
  include HTTParty
  attr_reader :api_key, :phone
  def initialize(phone)
    @api_key = ENV['API_KEY']
    @phone = phone
    @phone_uri = 'https://proapi.whitepages.com/2.0/phone.json?'
    @options = { query: { phone: phone, api_key: api_key } }
  end

  # get api response
  def json_response
    begin
      self.class.get(@phone_uri, @options)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
  end
end