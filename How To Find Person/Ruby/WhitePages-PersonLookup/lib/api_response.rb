require 'uri'
require 'httparty'
require 'json'
# create api request for find person and get response
class ApiResponse
  attr_reader :api_key, :first_name, :last_name, :address, :find_person_uri
  def initialize(api_key, first_name, last_name, address)
    @api_key = api_key
    @first_name = first_name.blank? ? '' : first_name.gsub(/\s/, '-')
    @last_name = last_name
    @address = address
    @find_person_uri = 'https://proapi.whitepages.com/2.0/person.json?'
  end

  # get api response
  def api_response
    begin
      HTTParty.get(build_uri)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
  end

  private

  # Build the appropriate URL
  def build_uri
    URI.escape(find_person_uri + "first_name=#{first_name}&last_name=#{last_name}&address=#{address}&api_key=#{api_key}")
  end
end