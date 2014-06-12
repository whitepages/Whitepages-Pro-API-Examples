require 'httparty'
require 'json'
require 'uri'
API_KEY = ""
BASE_URI= "http://proapi.whitepages.com/"
VERSION = "2.0/"

class ReverseAddressController < ApplicationController
  def index
    if request.post?
      unless params['street'].blank?
        @street = params['street']
        @city = params['city']
        request_url = BASE_URI + VERSION + "location.json?street_line_1="+URI.escape(@street) +"&city="+ URI.escape(@city) +"&api_key="+API_KEY
        @response = HTTParty.get(request_url)
        @response = JSON.parse(@response.to_json)
        @response["results"].blank?
        unless @response["results"].blank?
          @results_location_array = []
          @response["results"].each do|result_location|
            @results_location_array << result_location
          end

          @dictionaryData = @response['dictionary'];
          @city  = ""
          @postal_code  = ""
          @address  = ""
          @standard_address_line1 = ""
          @standard_address_line2  = ""
          @standard_address_location  = ""
          @usage  = ""
          @delivery_point = ""
          @is_receiving_mail  = ""
          @person_keys_array = []

          @results_location_array.each do|location_obj|
            locationObj = @dictionaryData[location_obj]
            @city = locationObj["city"]
            @postal_code =locationObj["postal_code"]
            @standard_address_line1 =locationObj["standard_address_line1"]
            @standard_address_line2 = locationObj["standard_address_line2"]
            @standard_address_location= locationObj["standard_address_location"]
            @usage = locationObj["usage"]
            @delivery_point = locationObj["delivery_point"]
            @is_receiving_mail = locationObj["is_receiving_mail"]!= false ? "Yes" : "No"

            legal_entities_at_array = locationObj['legal_entities_at']
            unless legal_entities_at_array.blank?
              legal_entities_at_array.each do |legal_entities_at_obj|
                legal_entities_obj = legal_entities_at_obj["id"]
                @person_keys_array <<  legal_entities_obj["key"]
              end
            end
          end

          @person_type_hash = Hash.new()
          @person_name_hash = Hash.new()
          @person_age_start_hash = Hash.new()
          @location_keys_hash = Hash.new()

          unless @person_keys_array.blank?
            @person_keys_array.each_with_index do|person_obj,person_index|
              personObj = @dictionaryData[person_obj]
              personObjId =  personObj["id"]
              @person_type_hash[person_index] = personObjId["type"] unless personObjId.blank?

              unless personObj["name"].blank?
                @person_name_hash[person_index] = personObj["name"]
              end

              unless personObj["names"].blank?
                personObjNames =  personObj["names"]
                unless personObjNames.blank?
                  first_name = personObjNames[0]["first_name"].blank? ? "" : personObjNames[0]["first_name"]+" "
                  middle_name = personObjNames[0]["middle_name"].blank? ? "" : personObjNames[0]["middle_name"]+" "
                  last_name =  personObjNames[0]["last_name"].blank? ? "" : personObjNames[0]["last_name"]
                  @person_name_hash[person_index] =  first_name +  middle_name +  last_name
                end
              end

              unless personObj["age_range"].blank?
                @person_age_start_hash[person_index] =  personObj["age_range"]["start"]
              end

            end
          end
        else
          unless @response["error"].blank?
            @error = @response["error"]['message']
          else
            @error = "no records found"
          end
        end
      else
        @error = "please enter address"
      end
    end

  end

end
