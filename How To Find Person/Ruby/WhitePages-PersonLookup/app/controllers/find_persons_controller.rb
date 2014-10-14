require 'api_response'
require 'parse_json_response'

class FindPersonsController < ApplicationController
  def index
  end

  def search
    response = ApiResponse.new(params['first_name'], params['last_name'], params['where'])
    api_response = response.json_response
    @results = { error: api_response['error']['message'] } unless api_response['error'].nil?
    unless api_response['results'].blank?
      person_obj = Person.new(api_response)
      @results = { result: person_obj.formatted_result }
    end
    render :action => :index
  end
end
