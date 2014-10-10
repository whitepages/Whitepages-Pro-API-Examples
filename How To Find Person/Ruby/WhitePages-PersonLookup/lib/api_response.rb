require 'uri'
require 'httparty'
require 'json'
class ApiResponse

  def initialize(api_key,first_name,last_name,address)
    @api_key=api_key
    @first_name= first_name.blank? ? "" : first_name.gsub(/\s/,'-')
    @last_name= last_name
    @address= address
    @find_person_uri = "https://proapi.whitepages.com/2.0/person.json?"
  end

  #get api response
  def get_person_details
    begin
      response = HTTParty.get(build_uri) || (raise Exception)
      return JSON.parse(response.to_json)
    rescue Exception => e
      Rails.logger.debug  "HTTPartyError:#{e}"
    end
  end

  private
#Build the appropriate URL
  def build_uri
    return URI.escape(@find_person_uri + "first_name=#{@first_name}&last_name=#{@last_name}&address=#{@address}&api_key=#{@api_key}")
  end

end