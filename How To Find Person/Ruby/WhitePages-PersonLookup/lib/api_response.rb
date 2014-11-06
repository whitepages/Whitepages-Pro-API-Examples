# create api request for find person and get response
class ApiResponse
  include HTTParty
  def initialize(first_name, last_name, address)
    @find_person_uri = 'https://proapi.whitepages.com/2.0/person.json?'
    @options = {
     query: {
      first_name: first_name,
      last_name: last_name,
      address: address,
      api_key: ENV['API_KEY']
     }
    }
  end

  # get api response
  def json_response
    begin
      self.class.get(@find_person_uri, @options)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
  end
end
