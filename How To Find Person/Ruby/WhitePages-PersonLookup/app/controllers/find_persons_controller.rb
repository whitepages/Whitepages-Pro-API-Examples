API_KEY = "6b5a968507f728b72bac005321001c28"
require "api_response"
require "parse_json_response"

class FindPersonsController < ApplicationController
  def index
    @results = Hash.new
    if request
      response = ApiResponse.new(API_KEY,params['first_name'],params['last_name'],params['where'])
      api_response = response.get_person_details
      unless api_response["error"].blank?
        @results["error"] = api_response["error"]["message"]
      else
        unless api_response["results"].blank?
          @results["result"] = Person.person_details(api_response)
        else
          @results["message"] = "no records found"
        end
      end
    end
  end
end
