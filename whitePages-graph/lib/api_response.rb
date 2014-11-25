# This class handles for api request and response.
require 'json'
require 'net/https'
require 'uri'

class ApiResponse
  def initialize(api_url)
    @api_url = api_url
  end

# get api response
  def json_response
    begin
      uri = URI.parse(@api_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.get(uri.request_uri)
      JSON.parse(response.body)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
  end
end