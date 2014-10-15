# This class handles for api request and response.
class ApiResponse
  include HTTParty
  attr_reader :api_key, :street, :city
  def initialize(street, city)
    @api_key = ENV['API_KEY']
    @street = street
    @city = city
    @address_uri = 'https://proapi.whitepages.com/2.0/location.json?'
    @options = { query: { street_line_1: street, city: city, api_key: api_key } }
  end

  # get api response
  def json_response
    begin
      self.class.get(@address_uri, @options)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
  end
end