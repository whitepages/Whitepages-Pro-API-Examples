class FindBusinessController < ApplicationController
  def index
    @search_for = 'business'
    if request.post?
      check_parameters = check_required_parameters(:api_key, :business_name, :city, :state)
      if check_parameters.blank?
        begin
          session[:encrypt_key] = GraphHelperLib.encrypt(params[:api_key], session[:encrypt_key])
          @graph_url = GraphHelperLib.find_business_api_url(params[:business_name], params[:city], params[:state], params[:api_key])
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
