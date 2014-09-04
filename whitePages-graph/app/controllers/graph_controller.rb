require 'graphviz'
require 'httparty'
require 'json'
require 'uri'

DEFAULT_FORMAT = { :fontsize=>8 , :fontname=>"monaco" }
NODE_ATTRIBUTES = {
 :shape => "rectangle",
 :fontsize => 8,
 :fontname => "Arial",
 :margin => "0.35,0.10",
 :penwidth => 1.0
}

EDGE_ATTRIBUTES = {
 :fontname => "Arial",
 :fontsize => 8,
 :penwidth => 1.3,
 :fontsize => 7,
 :color=>"#959595"
}

GRAPH_ATTRIBUTES = {
 :fontsize => 8,
 :fontname => "Arial",
 :color=>"mediumorchid3" ,
 :shape => "Mrecord"
}

class GraphController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_filter :remove_hard_image

  #function for createing request url and generate graph for phone page
  def index
    @api_key = ""
    if request.post?
      img_file_name = "whitepages-phone.svg"
      @error = ""
      @search_for = "phone"
      unless params[:api_key].blank?
        @api_key = params[:api_key]
        unless params[:phone_number].blank?
          @post = true
          @phone_number = params[:phone_number]
          @phone_number.strip!
          rquest_query_string = "https://proapi.whitepages.com/2.0/phone.json?phone=#{@phone_number}"
          @response = parse_data(rquest_query_string,img_file_name,@api_key)
        else
          if params[:phone_number].blank?
            @error = "please enter phone number."
          end
        end
      else
        @error = "please enter your api key."
      end
    end
  end

  #function for creating request URL and generate graph for business page
  def find_business
    @api_key = ""
    @business_name= ""
    @city = ""
    @state_code=""
    if request.post?
      img_file_name = "whitepages-business.svg"
      @error = ""
      @search_for = "business"
      unless params[:api_key].blank?
        @api_key = params[:api_key]
        @post = true
        unless params[:business_name].blank?
          @business_name= params[:business_name]
          unless params[:city].blank?
            @city = params[:city]
            unless params[:state].blank?
              @state_code = params[:state]
              rquest_query_string = URI.escape("https://proapi.whitepages.com/2.0/business.json?name=#{@business_name}&city=#{@city}&state=#{@state_code}" )
              @response = parse_data(rquest_query_string,img_file_name,@api_key)
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

  #function for creating request URL and generate graph for person page
  def person
    @api_key = ""
    @first_name = ""
    @last_name = ""
    @address = ""
    if request.post?
      img_file_name = "whitepages-person.svg"
      @error = ""
      unless params[:api_key].blank?
        @post = true
        @error = ""
        @api_key = params[:api_key]
        @search_for = "person"
        unless params[:person_first_name].blank?
          @first_name = params[:person_first_name]
          unless params[:person_last_name].blank?
            @last_name = params[:person_last_name]
            unless params[:person_where].blank?
              @address = params[:person_where]
              searchString = ""
              unless params[:person_first_name].blank?
                if searchString.length == 0
                  searchString = searchString + "first_name=#{@first_name}"
                else
                  searchString = searchString + "&first_name=#{@first_name}"
                end
              end
              unless params[:person_last_name].blank?

                if searchString.length == 0
                  searchString = searchString + "last_name=#{@last_name}"
                else
                  searchString = searchString + "&last_name=#{@last_name}"
                end
              end
              unless params[:person_where].blank?
                if searchString.length == 0
                  searchString = searchString + "address=#{@address}"
                else
                  searchString = searchString + "&address=#{@address}"
                end
              end
              @rquest_query_string = URI.escape("https://proapi.whitepages.com/2.0/person.json?#{searchString}" )
              @response = parse_data(@rquest_query_string,img_file_name,@api_key)
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

  #function for creating request URL and generate graph for address page
  def address
    @api_key = ""
    @standard_address_line1 =""
    @standard_address_location = ""
    if request.post?
      img_file_name = "whitepages-address.svg"
      @error = ""
      @search_for = "location"
      unless params[:api_key].blank?
        @api_key = params[:api_key]
        unless params[:address_street_line_1].blank?
          @standard_address_line1 = params[:address_street_line_1]
          unless params[:address_city].blank?
            @post = true
            @standard_address_location = params[:address_city]
            rquest_query_string = "https://proapi.whitepages.com/2.0/location.json?street_line_1=#{URI.escape(@standard_address_line1)}&city=#{URI.escape(@standard_address_location)}"
            @response = parse_data(rquest_query_string,img_file_name,@api_key)
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

  #function for rendering graph in search_graph template.
  def search_graph
  end

  #function for creating request URL and generate graph on node click
  def search
    unless params["url"].blank?
      @flag = false
      @search_for = ''
      @address =""
      @phone_number = params["phone"]
      @api_key = params["url"].to_s.split('api_key=').last
      response = HTTParty.get(params["url"])
      if response.code == 200
        response_json = JSON.parse(response.to_json)
        unless response_json["results"].blank?
          results_data = response_json["results"].first
          if results_data.include? "Location"
            @standard_address_line1 =  response_json["dictionary"][results_data]["standard_address_line1"]
            @standard_address_location =  response_json["dictionary"][results_data]["standard_address_location"]
            @flag = true
            @search_for = "location"
            rquest_query_string = "https://proapi.whitepages.com/2.0/location.json?street_line_1=#{URI.escape(@standard_address_line1)}&city=#{URI.escape(@standard_address_location)}"

          elsif  results_data.include? "Phone"
            @phone_number =  response_json["dictionary"][results_data]["phone_number"]
            @flag = true
            @search_for = "phone"
            rquest_query_string = "https://proapi.whitepages.com/2.0/phone.json?phone=#{@phone_number}"
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
            rquest_query_string = URI.escape("https://proapi.whitepages.com/2.0/person.json?#{searchString}" )
          elsif  results_data.include? "Business"
            @business_name =  response_json["dictionary"][results_data]["name"]
            unless response_json["dictionary"][results_data]["locations"][0].blank?
              locations_key = response_json["dictionary"][results_data]["locations"][0]["id"]["key"]
              @city =  response_json["dictionary"][locations_key]["city"]
              @state_code =  response_json["dictionary"][locations_key]["state_code"]
            end
            @flag = true
            @search_for = "business"
            rquest_query_string = URI.escape("https://proapi.whitepages.com/2.0/business.json?name=#{@business_name}&city=#{@city}&state=#{@state_code}" )
          end

          if rquest_query_string
            @response = parse_data(rquest_query_string,'graph_search.svg',@api_key)
            respond_to do |format|
              format.js
            end
          end
        end
      end
    end
  end

  #function for create request and parse json response. Create graph file (.svg).	
  def parse_data(query,img,api_key)
    ARGV[0] = query
    ARGV[1] = img
    if(ARGV[0] && ARGV[1])
      request = ARGV[0] + "&api_key=#{api_key}"
      # make a request to whitepages
      response = HTTParty.get(request)
      # Create a new graph
      g = GraphViz::new( "#" ,:use => "dot" )
      { labelloc: "t" }.merge(DEFAULT_FORMAT).each { |k, v| g[k] = v }

      dictionary = response["dictionary"]
      results = response["results"]

      unless results.nil?
        @results_size = results.size
        unfulfilled_nodes = { }
        # build the nodes in the graph
        node_title = ""
        unless dictionary.blank?
          dictionary.each do |(key, value)|
            node_format = { }
            node_text = ""

            case value["id"]["type"]
              when "Person"
                # Added metadata for phone in title attribute 
                node_title = "Name: " + value["best_name"].to_s + "&#10;"  if value["best_name"]
                node_title = node_title + "Type: " + value["id"]["type"].to_s + "&#10;"  if value["id"]["type"]
                node_title = node_title + "Age: " + value["age_range"]["start"].to_s + " - " + value["age_range"]["end"].to_s + "&#10;"  if value["age_range"] 
                node_text = value["best_name"] 
              when "Phone"
                country_calling_code = ""
                if value["country_calling_code"]
                  country_calling_code = "+" + value["country_calling_code"]
                end
                node_title = "Phone Number: " + country_calling_code + " " + number_to_phone(value["phone_number"]) + "&#10;"  if value["phone_number"]
                node_title = node_title + "Carrier: " + value["carrier"].to_s + "&#10;"  if value["carrier"]
                node_title = node_title + "Phone Type: " + value["line_type"].to_s + "&#10;"  if value["line_type"]

                do_not_call = ""
                if value["do_not_call"]
                  do_not_call = "Registered"
                else
                  do_not_call = "Not Registered"
                end
                node_title = node_title + "Do Not Call Registry: " + do_not_call.to_s + "&#10;"
                if value["reputation"]
                  spam_score = value["reputation"]["spam_score"].to_s + "%"
                else
                  spam_score = "0".to_s + "%"
                end
                node_title = node_title + "Spam Score: " + spam_score + "&#10;"
                node_text = value["phone_number"] 
              when "Location"
                node_title = ""
                receiving_mail = "No"
                if value["is_receiving_mail"]
                  receiving_mail = "Yes"
                end
                usage = "Not defined"
                if value["usage"]
                  usage =  value["usage"].to_s
                end
                delivery_point = "Not defined"
                if value["delivery_point"]
                  delivery_point =  value["delivery_point"].to_s.split('Unit').first.to_s + " Unit"
                end
                node_title = "Usage: " + usage + "&#10;"
                node_title =  node_title + "Receiving Mail: " + receiving_mail.to_s + "&#10;"
                node_title =  node_title + "Delivery Point: " + delivery_point

                [value["standard_address_line1"], value["standard_address_line2"], value["standard_address_location"]].each do |v|
                  if v && !v.length.zero?
                    node_text << '\n' unless node_text.length.zero?
                    node_text << v
                  end
                end 
              when "Business"
                node_title = "Business Name: " + value["name"].to_s + "&#10;"  if value["name"]
                node_text = value["name"] 
              else
                node_text = "unknown"
            end
            associated_locations_url = "#"
            unless dictionary[results[0]]["associated_locations"].blank?
              associated_locations_url = dictionary[results[0]]["associated_locations"][0]["id"]["url"]
            end 

            node_text << "\n" << value["id"]["type"] << "\n" << value["id"]["durability"]

            if value["id"]["type"] == "Person"
              node_color = "#8dbd40"
            elsif value["id"]["type"] == "Location"
              node_color = "#46a3cc"
            elsif value["id"]["type"] == "Business"
              node_color = "#7ACC00"
            elsif value["id"]["type"] == "Phone"
              node_color = "#CC9F18"
            end

            # build the nodes 
            value["node"] = g.add_nodes(node_text, { "tooltip" => node_title, color:node_color }.merge(DEFAULT_FORMAT).merge(NODE_ATTRIBUTES))
            value["node"]["URL"] = "##{value["id"]["url"].nil? ? associated_locations_url : value["id"]["url"]}"
          end

          # build the edges
          unfulfillednode_title = ""
          dictionary.each do |(key, value)|
            edge_sets = [{edges: (value["locations"] || []).select{|x| x["is_historical"] == true} , descr: "historical"},
             {edges: (value["locations"] || []).select{|x| x["is_historical"] == false}, descr: "location"},
             {edges: value["phones"] || [], descr: "phone"},
             {edges: value["legal_entities_at"] || [], descr: "legal&#10;entity at"},
             {edges: value["belongs_to"] || [], descr: "belongs to"},
             {edges: value["associated_locations"] || [], descr: "associated&#10;location"},
            ]

            edge_sets.each do |edge_set|
              edge_set[:edges].each do |edge|
                url = edge["id"]["url"].nil? ? "#" : edge["id"]["url"]
                destination_node = (dictionary[edge["id"]["key"]] && dictionary[edge["id"]["key"]]["node"]) ||
                 unfulfilled_nodes[edge["id"]["key"]] ||
                 unfulfilled_nodes[edge["id"]["key"]] = g.add_nodes(edge["id"]["key"], {"URL" => "##{url}" ,"tooltip" => "#"}.merge(GRAPH_ATTRIBUTES))

                e = g.add_edges( value["node"], destination_node, { label: edge_set[:descr], tooltip: edge_set[:descr]}.merge(EDGE_ATTRIBUTES) )
              end
            end
          end
        end

        unless results.blank?
          # nodes style and shape
          results.each do |key|
            dictionary[key]["node"]["style"] = "filled"
            dictionary[key]["node"]["fillcolor"] = "#46a3cc"
            dictionary[key]["node"]["color"] = "#46a3cc"
            dictionary[key]["node"]["shape"] = "rectangle"
            dictionary[key]["node"]["fontcolor"] = "white"
            dictionary[key]["node"]["margin"] = "0.35,0.10"

          end

          # gray the unfulfilled nodes style and shape
          unfulfilled_nodes.each do |(k, v)|
            v["style"] = "filled"
            v["fillcolor"] = "#cccccc"
            v["color"] = "#cccccc"
            v["shape"] = "circle"
            v["width"] = '0.70' 
            v["fixedsize"] = 'true'
            v["label"] = k.to_s.split('.').first.capitalize
            v["tooltip"] = k.to_s.split('.').first.capitalize
          end

          # output as SVG 
          g.output(:svg => ARGV[1])
          fileName =  File.join(Rails.root, '/'+ARGV[1])

          if File::exist?( fileName)
            File.chmod(0777, fileName)
            FileUtils.mv(fileName,'./public')
          end
        else
          @error = "No records found"

        end
      else
        @error = "No records found"

      end
    else
      puts "USAGE: ruby graphviz-response.rb APIrequest outputSVG"
    end
  end

  #function to remove all old svg images
  def remove_hard_image
    file_phone =  File.join(Rails.root, 'public/whitepages-phone.svg')
    file_address =  File.join(Rails.root, 'public/whitepages-address.svg')
    file_person =  File.join(Rails.root, 'public/whitepages-person.svg')
    file_graph_search =  File.join(Rails.root, 'public/graph_search.svg')
    file_business =  File.join(Rails.root, 'public/whitepages-business.svg')

    if File::exist?( file_phone)
      File.delete(file_phone)
    end

    if File::exist?(file_address)
      File.delete(file_address)
    end

    if File::exist?(file_person)
      File.delete(file_person)
    end

    if File::exist?(file_business)
      File.delete(file_business)
    end

    if File::exist?( file_graph_search)
      File.delete(file_graph_search)
    end
  end

end
