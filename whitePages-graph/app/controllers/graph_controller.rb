require 'graphviz'
require 'httparty'
require 'json'
require 'uri'
require 'graph'
require "white_pages_api"

class GraphController < ApplicationController
  #creating request API url for 'Find by Phone Number' tab
  def index
    @api_key,@error = "" ,""
    if request.post?
      @search_for = "phone"
      @api_key = params[:api_key]
      @phone_number = params[:phone_number]
      @phone_number.strip!
      unless params[:api_key].blank?
        unless params[:phone_number].blank?
          wp_obj = WhitePagesApi.new(@api_key)
          wp_obj.phone = @phone_number
          @graph_url = wp_obj.get_phone_url
        else
          @error = "please enter phone number."
        end
      else
        @error = "please enter your api key."
      end
    end
  end

  #creating request API url for 'Find by Address' tab
  def address
    @api_key,@standard_address_line1,@standard_address_location  = "","",""
    if request.post?
      @error = ""
      @search_for = "location"
      @api_key = params[:api_key]
      @standard_address_line1 = params[:address_street_line_1]
      @standard_address_location = params[:address_city]
      unless params[:api_key].blank?
        unless params[:address_street_line_1].blank?
          unless params[:address_city].blank?
            wp_obj = WhitePagesApi.new(@api_key)
            wp_obj.street_line_1 = @standard_address_line1
            wp_obj.city = @standard_address_location
            @graph_url = wp_obj.get_location_url
          else
            @error = "please enter city and state or Zip."
          end
        else
          @error = "please enter street address or name."
        end
      else
        @error = "please enter your api key."
      end
    end
  end

  #creating request API url for 'Find Person' tab
  def person
    @api_key, @first_name ,@last_name,@address,@error = "", "","","",""
    if request.post?
      @error = ""
      searchString = ""
      unless params[:api_key].blank?
        @api_key = params[:api_key]
        @search_for = "person"
        @first_name = params[:person_first_name]
        @last_name = params[:person_last_name]
        @address = params[:person_where]
        unless params[:person_first_name].blank?
          unless params[:person_last_name].blank?
            unless params[:person_where].blank?
              searchString = searchString + "first_name=#{@first_name}"  + "&last_name=#{@last_name}"  + "&address=#{@address}"
              wp_obj = WhitePagesApi.new(@api_key)
              wp_obj.first_name = @first_name
              wp_obj.last_name = @last_name
              wp_obj.address = @address
              @graph_url = wp_obj.get_person_url
            else
              @error = "please enter address."
            end
          else
            @error = "please enter last name."
          end
        else
          @error = "please enter first name."
        end
      else
        @error = "please enter your api key."
      end
    end
  end

  #creating request API url for 'Find Business' tab
  def find_business
    @api_key,@business_name,@city,@state_code,@error = "","","","",""

    if request.post?
      @search_for = "business"
      @api_key = params[:api_key]
      @business_name= params[:business_name]
      @city = params[:city]
      @state_code = params[:state]
      unless params[:api_key].blank?
        unless params[:business_name].blank?
          unless params[:city].blank?
            unless params[:state].blank?
              wp_obj = WhitePagesApi.new(@api_key)
              wp_obj.business_name = @business_name
              wp_obj.city = @city
              wp_obj.state = @state_code
              @graph_url = wp_obj.get_business_url
            else
              @error = "please enter state."
            end
          else
            @error = "please enter city."
          end
        else
          @error = "please enter business name."
        end
      else
        @error = "please enter your api key."
      end
    end
  end

  #function for creating graph from URL
  def search
    unless params["url"].blank?
      @flag = false
      @error = ""
      @search_for = ''
      @address =""
      @api_key = params["url"].to_s.split('api_key=').last
      if params["url"].to_s.include? "Durable.json"
        response = HTTParty.get(params["url"])
        response_json = JSON.parse(response.to_json)
        graph_from_link(response_json,@api_key) if response.code == 200
      else
        graph_from_form(params["url"])
      end

      respond_to do |format|
        format.js
      end
    end
  end

  #function for creating request API URL and generate graph using Graph module on node click
  def graph_from_link(response_json,api_key)
    unless response_json["results"].blank?
      results_data = response_json["results"].first
      if results_data.include? "Location"
        @standard_address_line1 =  response_json["dictionary"][results_data]["standard_address_line1"]
        @standard_address_location =  response_json["dictionary"][results_data]["standard_address_location"]
        @flag = true
        @search_for = "location"
        wp_obj = WhitePagesApi.new(api_key)
        wp_obj.street_line_1 = @standard_address_line1
        wp_obj.city = @standard_address_location
        request_query_string = wp_obj.get_location_url

      elsif  results_data.include? "Phone"
        @phone_number =  response_json["dictionary"][results_data]["phone_number"]
        @flag = true
        @search_for = "phone"
        wp_obj = WhitePagesApi.new(api_key)
        wp_obj.phone = @phone_number
        request_query_string = wp_obj.get_phone_url

      elsif  results_data.include? "Person"
        searchString = ""
        unless response_json["dictionary"][results_data]["names"][0].blank?
          @first_name =  response_json["dictionary"][results_data]["names"][0]["first_name"]
          @last_name =  response_json["dictionary"][results_data]["names"][0]["last_name"]
          searchString = searchString + "first_name=#{@first_name}" + "&last_name=#{@last_name}"
        end

        unless response_json["dictionary"][results_data]["locations"][0].blank?
          locations_key = response_json["dictionary"][results_data]["locations"][0]["id"]["key"]
          @standard_address_line1 =  response_json["dictionary"][locations_key]["standard_address_line1"]
          @standard_address_location =  response_json["dictionary"][locations_key]["standard_address_location"]
          @address = "#{@standard_address_line1} #{@standard_address_location}"
          searchString = searchString + "&address=#{@standard_address_line1} #{@standard_address_location}"
        end

        unless response_json["dictionary"][results_data]["best_location"].blank?
          locations_key = response_json["dictionary"][results_data]["best_location"]["id"]["key"]
          @standard_address_line1 =  response_json["dictionary"][locations_key]["standard_address_line1"]
          @standard_address_location =  response_json["dictionary"][locations_key]["standard_address_location"]
          @address = "#{@standard_address_line1} #{@standard_address_location}"
          searchString = searchString + "&address=#{@standard_address_line1} #{@standard_address_location}"
        end

        @flag = true
        @search_for = "person"
        wp_obj = WhitePagesApi.new(api_key)
        wp_obj.first_name = @first_name
        wp_obj.last_name = @last_name
        wp_obj.address = @address
        request_query_string = wp_obj.get_person_url

      elsif  results_data.include? "Business"
        @business_name =  response_json["dictionary"][results_data]["name"]
        unless response_json["dictionary"][results_data]["locations"][0].blank?
          locations_key = response_json["dictionary"][results_data]["locations"][0]["id"]["key"]
          @city =  response_json["dictionary"][locations_key]["city"]
          @state_code =  response_json["dictionary"][locations_key]["state_code"]
        end
        @flag = true
        @search_for = "business"

        wp_obj = WhitePagesApi.new(api_key)
        wp_obj.business_name = @business_name
        wp_obj.city = @city
        wp_obj.state = @state_code
        request_query_string = wp_obj.get_business_url
      end
      @results_size = Graph.create_svg(URI.unescape(request_query_string),'graph_search.svg')  if request_query_string
    end
  end


  #function for getting form attributes from link and creating request API url and generate graph using Graph module
  def graph_from_form(url)
    if url.include? "location"
      str_params = url.to_s.split('json?').last
      location_params = str_params.to_s.split('&')
      @standard_address_line1 =  URI.unescape(location_params[0].to_s.split('=').last)
      @standard_address_location =  URI.unescape(location_params[1].to_s.split('=').last)
      @flag = true
      @search_for = "location"
    elsif url.include? "phone"
      str_params = url.to_s.split('json?').last
      phone_params = str_params.to_s.split('&')
      @phone_number =   URI.unescape(phone_params[0].to_s.split('=').last)
      @flag = true
      @search_for = "phone"
    elsif  url.include? "person"
      @flag = true
      @search_for = "person"
      str_params = url.to_s.split('json?').last
      person_params = str_params.to_s.split('&')
      @first_name = URI.unescape(person_params[0].to_s.split('=').last)
      @last_name =  URI.unescape(person_params[1].to_s.split('=').last)
      @address =  URI.unescape(person_params[2].to_s.split('=').last)
    elsif url.include? "business"
      @flag = true
      @search_for = "business"
      str_params = url.to_s.split('json?').last
      business_params = str_params.to_s.split('&')
      @business_name = URI.unescape(business_params[0].to_s.split('=').last)
      @city  =  URI.unescape(business_params[1].to_s.split('=').last)
      @state_code =  URI.unescape(business_params[2].to_s.split('=').last)
    end
    @results_size = Graph.create_svg(URI.unescape(url),'graph_search.svg')
  end

end
