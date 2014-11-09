require 'api_response'

class ReversePhoneController < ApplicationController
# method for getting people and location details associated with phone.
  def search
    begin
      api_response = ApiResponse.new(params['phone']).json_response
      unless api_response['error'].nil?
        @results = { error: api_response['error']['message'] }
      else
        phone_obj = Phone.new(api_response)
        @results = { result: phone_obj.formatted_result }
      end
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
    render :action => :index
  end
end
