require 'api_response'

class ReverseAddressController < ApplicationController
  def search
    api_response = ApiResponse.new(params['street'], params['city']).json_response
    unless api_response['error'].nil?
      @results = { error: api_response['error']['message'] }
    else
      address_obj = Address.new(api_response)
      @results = { result: address_obj.formatted_result }
    end
    render :action => :index
  end
end
