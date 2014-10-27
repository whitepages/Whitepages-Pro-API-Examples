require 'api_response'

class ReversePhoneController < ApplicationController
  def index
  end

# method for getting people and location details associated with phone.
  def search
    response = ApiResponse.new(params['phone'])
    api_response = response.json_response
    @results = { error: api_response['error']['message'] } unless api_response['error'].nil?
    unless api_response['results'].blank?
      phone_obj = Phone.new(api_response)
      @results = { result: phone_obj.formatted_result }
    end
    render :action => :index
  end
end
