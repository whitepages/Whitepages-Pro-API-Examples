# This class handles for api request and response.
class ApiResponse
  include HTTParty

  def initialize(street, city)
    @address_url = 'https://proapi.whitepages.com/2.0/location.json?'
    @options = { query: { street_line_1: street, city: city, api_key: ENV['API_KEY'] } }
  end

  # get api response
  def json_response
    begin
      self.class.get(@address_url, @options)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
  end
end