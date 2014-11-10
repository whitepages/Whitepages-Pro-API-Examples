require 'api_response'

class ReversePhoneController < ApplicationController
# method for getting people and location details associated with phone.
  def search
    begin
      api_response = ApiResponse.new(params['phone']).json_response
      unless api_response['error'].nil?
        @results = { error: api_response['error']['message'] }
      else
        results = api_response['results'].map do |id|
          phone = Phone.new(api_response['dictionary'][id])
          belongs_to = phone.belongs_to
          {
           phone: phone.data,
           people: belongs_to.map do |belongs_to_id|
             Person.new(api_response['dictionary'][belongs_to_id]).data if belongs_to_id
           end.reject(&:blank?),
           location: belongs_to.map do |belongs_to_id|
             best_location = Person.new(api_response['dictionary'][belongs_to_id]).best_location if belongs_to_id
             Location.new(api_response['dictionary'][best_location]).data if best_location
           end.reject(&:blank?),
          }
        end.reject(&:blank?)
        @results = { result: results }
      end
    rescue => e
      Rails.logger.debug "Error:#{e}"
    end
    render :action => :index
  end
end
