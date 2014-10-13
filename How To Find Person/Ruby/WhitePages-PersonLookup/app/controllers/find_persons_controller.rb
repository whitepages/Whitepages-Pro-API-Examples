API_KEY = ''
require 'api_response'
require 'parse_json_response'

class FindPersonsController < ApplicationController
  def index
    if request.post?
      @results = {}
      response = ApiResponse.new(API_KEY, params['first_name'], params['last_name'], params['where'])
      api_response = response.api_response
      @results['error'] = api_response['error']['message'] if api_response['error']
      unless api_response['results'].blank?
        person_obj = Person.new(api_response)
        @results['result'] = person_obj.formatted_result
      end
    end
  end
end
