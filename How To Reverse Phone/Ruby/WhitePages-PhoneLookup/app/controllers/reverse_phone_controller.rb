require 'api_response'

class ReversePhoneController < ApplicationController
# method for getting people and location details associated with phone.
  def search
    begin
      api_response = ApiResponse.new(params['phone']).json_response
      @results = Result.new(api_response)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
    render :action => :index
  end
end
