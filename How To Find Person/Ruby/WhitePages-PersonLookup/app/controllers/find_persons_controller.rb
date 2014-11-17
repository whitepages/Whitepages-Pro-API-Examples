require 'api_response'

class FindPersonsController < ApplicationController
  def search
    begin
      req_params = { :first_name => params['first_name'],
                     :last_name => params['last_name'],
                     :address => params['address'] }
      api_response = ApiResponse.new(req_params).json_response
      @results = Result.new(api_response)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
    render :action => :index
  end
end
