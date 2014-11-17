require 'api_response'

class ReversePhoneController < ApplicationController
# method for getting people and location details associated with phone.
  def search
    begin
      req_params = { :phone => params['phone'] }
      api_response = ApiResponse.new(req_params).json_response
      @results = Result.new(api_response)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
    render :action => :index
  end
end
