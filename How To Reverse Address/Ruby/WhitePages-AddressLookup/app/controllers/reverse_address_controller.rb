require 'api_response' 

class ReverseAddressController < ApplicationController

  def search
    begin
      req_params = { :street_line_1 => params['street'],
                     :city => params['city'] }
      api_response = ApiResponse.new(req_params).json_response
      @results = Result.new(api_response)
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
    render :action => :index
  end
end
