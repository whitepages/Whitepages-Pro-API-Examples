# This class handles for api request and response.
require 'json'
require 'net/https'
require 'uri'

class ApiResponse
  def initialize(params)
    @api_version = '2.0'
    @base_uri = 'https://proapi.whitepages.com/'
    @params =  params.merge({:api_key => ENV['API_KEY']})
    @reverse_address_uri = reverse_address_uri
  end

  def reverse_address_uri
    @base_uri + @api_version + '/location.json?' + @params.to_query(namespace = nil)
  end

  # get api response
  def json_response
    begin
      uri = URI.parse(@reverse_address_uri)
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