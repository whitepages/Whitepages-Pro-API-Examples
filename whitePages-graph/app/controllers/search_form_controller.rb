class SearchFormController < ApplicationController
  include SearchFormHelper
  def index
    begin
      unless params['url'].blank?
        params[:api_key] = params['url'].to_s.split('api_key=').last
        session[:encrypt_key] = GraphHelperLib.encrypt(params[:api_key], session[:encrypt_key])
        create_graph(params['url'])
        respond_to do |format|
          format.js
        end
      end
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
  end

  def create_graph(url)
    @requested_uri = url
    parameters_form(url)
    @result_graph = GraphHelperLib.create_svg(session[:encrypt_key], @requested_uri)
  end 
end
