require 'api_response' 

class ReverseAddressController < ApplicationController
  def index
  end

  def search
    response = ApiResponse.new(params['street'], params['city'])
    api_response = response.json_response
    @results = { error: api_response['error']['message'] } unless api_response['error'].nil?
    unless api_response['results'].blank?
      address_obj = Address.new(api_response)
      @results = { result: address_obj.formatted_result }
    end
    render :action => :index
  end
end
