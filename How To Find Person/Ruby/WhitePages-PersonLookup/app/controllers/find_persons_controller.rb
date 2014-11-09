require 'api_response'

class FindPersonsController < ApplicationController
  def search
    begin
      api_response = ApiResponse.new(params['first_name'], params['last_name'], params['where']).json_response
      unless api_response['error'].nil?
        @results = { error: api_response['error']['message'] }
      else
        person_obj = Person.new(api_response)
        @results = { result: person_obj.formatted_result }
      end
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
    render :action => :index
  end
end
