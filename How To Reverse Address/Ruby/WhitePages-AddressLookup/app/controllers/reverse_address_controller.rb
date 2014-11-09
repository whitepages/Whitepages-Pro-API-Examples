require 'api_response'

class ReverseAddressController < ApplicationController
  def search
     begin
      api_response = ApiResponse.new(params['street'], params['city']).json_response
      unless api_response['error'].nil?
        @results = { error: api_response['error']['message'] }
      else
        address_obj = Address.new(api_response)
        @results = { result: address_obj.formatted_result }
      end
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
    render :action => :index
  end
end
