class ReversePhoneController < ApplicationController
  def index
    @search_for = 'phone'
    if request.post?
      check_parameters = check_required_parameters(:api_key, :phone_number)
      if check_parameters.blank?
        begin
          session[:encrypt_key] = GraphHelperLib.encrypt(params[:api_key], session[:encrypt_key])
          @graph_url = GraphHelperLib.reverse_phone_api_url(params[:phone_number], params[:api_key])
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
