require 'api_response'

class FindPersonsController < ApplicationController
  def search
    begin
      api_response = ApiResponse.new(params['first_name'], params['last_name'], params['where']).json_response
      @results = Result.new(api_response)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
    render :action => :index
  end
end
