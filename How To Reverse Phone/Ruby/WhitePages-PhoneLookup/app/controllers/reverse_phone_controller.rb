require 'httparty'
require 'json'
require 'uri'
API_KEY = ""
BASE_URI= "http://proapi.whitepages.com/"
VERSION = "2.0/"

class ReversePhoneController < ApplicationController
  def index
    if request.post?
      unless params['phone'].blank?
        @phone = params['phone']
        request_url = BASE_URI + VERSION + "phone.json?phone="+ @phone  +"&api_key="+API_KEY
        @response = HTTParty.get(URI.escape(request_url))
        @response = JSON.parse(@response.to_json)
        unless @response["results"].blank?
          @results_phones_array = []
          @response["results"].each do|result_phone|
            @results_phones_array << result_phone
          end

          @dictionaryData = @response['dictionary'];
          @line_type = ""
          @person_keys_array= []
          @phone_number = ""
          @country_calling_code  = ""
          @carrier   = ""
          @do_not_call  = ""
          @reputation   = ""
          @location_keys_array   = []
          @results_phones_array.each do|phone_obj|
            phoneObj = @dictionaryData[phone_obj]
            @line_type  =  phoneObj['line_type']
            belongs_to_array = phoneObj['belongs_to']

            belongs_to_array.each do |belongs_to_obj|
              belongs_obj = belongs_to_obj["id"]
              @person_keys_array <<  belongs_obj["key"]
            end

            @phone_number   =  phoneObj['phone_number']
            @country_calling_code   =  phoneObj['country_calling_code']
            @carrier   = phoneObj['carrier']
            @do_not_call  =  phoneObj['do_not_call']!= false ? "Registered" : "Not Registered"
            @reputation  = phoneObj['reputation'].blank? ? 0 : phoneObj['reputation']

            best_location_array = phoneObj['best_location']
            unless best_location_array.blank?
              best_location_id = best_location_array["id"]
              @location_keys_array <<  best_location_id["key"]
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

              unless personObj["locations"].blank?
                @location_keys_array  = []
                personObj["locations"].each do|locations_obj|
                  @location_keys_hash[person_index] = locations_obj['id']['key']
                end
              end

              unless personObj["best_location"].blank?
                best_location_id = personObj["best_location"]["id"]
                unless best_location_id.blank?
                  @location_keys_array = []
                  @location_keys_hash[person_index] = best_location_id['key']
                end
              end
            end
          end

          @city  = Hash.new()
          @postal_code  = Hash.new()
          @address = Hash.new()
          @standard_address_line1  = Hash.new()
          @standard_address_line2  = Hash.new()
          @standard_address_location  = Hash.new()
          @usage  = Hash.new()
          @delivery_point = Hash.new()
          @is_receiving_mail = Hash.new()


          unless @location_keys_hash.blank?
            @location_keys_hash.each {|key, value|
              locationObj = @dictionaryData[value]
              @city[key] = locationObj["city"]
              @postal_code[key] =locationObj["postal_code"]
              @standard_address_line1[key] =locationObj["standard_address_line1"]
              @standard_address_line2[key] = locationObj["standard_address_line2"]
              @standard_address_location[key] = locationObj["standard_address_location"]
              @usage[key] = locationObj["usage"]
              @delivery_point[key] = locationObj["delivery_point"]
              @is_receiving_mail[key] = locationObj["is_receiving_mail"]!= false ? "Yes" : "No"
            }
          end

          unless @location_keys_array.blank?
            @location_keys_hash[0] = @location_keys_array[0]
            locationObj = @dictionaryData[@location_keys_array[0]]
            @city[0] = locationObj["city"]
            @postal_code[0] =locationObj["postal_code"]
            @standard_address_line1[0] =locationObj["standard_address_line1"]
            @standard_address_line2[0] = locationObj["standard_address_line2"]
            @standard_address_location[0] = locationObj["standard_address_location"]
            @usage[0] = locationObj["usage"]
            @delivery_point[0] = locationObj["delivery_point"]
            @is_receiving_mail[0] = locationObj["is_receiving_mail"]!= false ? "Yes" : "No"
          end
        else
          @error = @response["error"]['message']
        end
      else
        @error = "please enter phone number"
      end
    end

  end

end
