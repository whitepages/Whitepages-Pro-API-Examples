require 'httparty'
require 'json'
require 'uri'
API_KEY = ""
BASE_URI= "http://proapi.whitepages.com/"
VERSION = "2.0/"

class ReversePersonController < ApplicationController
  def index
    if request.post?
      if !params['first_name'].blank? && !params['last_name'].blank? && !params['where'].blank?
        @first_name = params['first_name'].gsub(/\s/,'-')
        @last_name = params['last_name']
        @where = params['where']
        request_url = BASE_URI + VERSION + "person.json?first_name="+URI.escape(@first_name) +"&last_name="+ URI.escape(@last_name) +"&address="+ URI.escape(@where) +"&api_key="+API_KEY

        @response = HTTParty.get(request_url)
        @response = JSON.parse(@response.to_json)
        # render :text=> @response and return
        unless @response["results"].blank?
          @result_persons_array = []
          @response["results"].each do|result_persons|
            @result_persons_array << result_persons
          end

          @dictionaryData = @response['dictionary'];
          @person_type_hash = Hash.new()
          @person_name_hash = Hash.new()
          @person_age_start_hash = Hash.new()
          @location_keys_hash = Hash.new()

          unless @result_persons_array.blank?
            @result_persons_array.each_with_index do|person_obj,person_index|
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
                personObj["locations"].each do|locations_obj|
                  @location_keys_hash[person_index] = locations_obj['id']['key']
                end
              end

              unless personObj["best_location"].blank?
                best_location_id = personObj["best_location"]["id"]
                unless best_location_id.blank?
                  @location_keys_hash[person_index] = ""
                  @location_keys_hash[person_index] = best_location_id['key']
                end
              end
            end
            #for locations
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
          end
        else
          if @response["results"].blank?
            @error = "no records found"
          elsif !@response["error"]
            @error = @response["error"]['message']
          end
        end
      else
        if params['first_name'].blank?
          @error = "Please enter first name"
        elsif params['last_name'].blank?
          @error = "Please enter last name"
        elsif params['where'].blank?
          @error = "Please enter city, state, zip or address"
        end
      end
    end

  end

end
