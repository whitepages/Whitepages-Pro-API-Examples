require 'api_response'

class ReverseAddressController < ApplicationController
  def search
    begin
      api_response = ApiResponse.new(params['street'], params['city']).json_response
      @results = Result.new(api_response)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
    render :action => :index
  end
end
