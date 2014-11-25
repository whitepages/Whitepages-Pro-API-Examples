class ReverseAddressController < ApplicationController
  def index
    @search_for = 'location'
    if request.post?
      check_parameters = check_required_parameters(:api_key, :address_street_line_1, :address_city)
      if check_parameters.blank?
        begin
          session[:encrypt_key] = GraphHelperLib.encrypt(params[:api_key], session[:encrypt_key])
          @graph_url = GraphHelperLib.reverse_address_api_url(params[:address_street_line_1], params[:address_city], params[:api_key])
          render :action => :graph_url
        rescue => e
          Rails.logger.debug "Error:#{e}"
        end
      else
        @error = check_parameters
      end
    end
  end
end
