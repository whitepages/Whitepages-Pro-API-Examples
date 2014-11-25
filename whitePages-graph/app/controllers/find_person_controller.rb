class FindPersonController < ApplicationController
  def index
    @search_for = 'person'
    if request.post?
      check_parameters = check_required_parameters(:api_key, :person_first_name, :person_last_name, :person_where)
      if check_parameters.blank?
        begin
          session[:encrypt_key] = GraphHelperLib.encrypt(params[:api_key], session[:encrypt_key])
          @graph_url = GraphHelperLib.find_person_api_url(params[:person_first_name], params[:person_last_name], params[:person_where], params[:api_key])
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
