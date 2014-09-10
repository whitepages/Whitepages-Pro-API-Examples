module Graph
  # Graphviz tool to produce visualizations of data.
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

  def self.create_svg(query,img)
    ARGV[0] = query
    ARGV[1] = img
    if(ARGV[0] && ARGV[1])
      request = URI.escape(ARGV[0])
      # make a request to whitepages
      response = HTTParty.get(request)
      # Create a new graph
      g = GraphViz::new( "#" ,:use => "dot" )
      { labelloc: "t" }.merge(DEFAULT_FORMAT).each { |k, v| g[k] = v }

      dictionary = response["dictionary"]
      results = response["results"]

      unless results.nil?
        results_size = results.size
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
                node_title = "Phone Number: " + country_calling_code + " " + ActionController::Base.helpers.number_to_phone(value["phone_number"]) + "&#10;"  if value["phone_number"]
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
          return results_size
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
end