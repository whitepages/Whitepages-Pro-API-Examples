module SearchLinkHelper
  def parameters_from_links(url, api_key)
    response_json =  ApiResponse.new(url).json_response
    unless response_json['results'].blank?
      results_data = response_json['results'].first
      if results_data.include? 'Location'
        parameters = GraphHelperLib.location_parameters(response_json, results_data)
        graph_parameters(parameters, :address_street_line_1, :address_city)
        @search_for = 'location'
        GraphHelperLib.reverse_address_api_url(params[:address_street_line_1], params[:address_city], api_key)
      elsif results_data.include? 'Phone'
        parameters = GraphHelperLib.phone_parameters(response_json, results_data)
        graph_parameters(parameters, :phone_number)
        @search_for = 'phone'
        GraphHelperLib.reverse_phone_api_url(params[:phone_number], api_key)
      elsif results_data.include? 'Person'
        parameters = GraphHelperLib.person_parameters(response_json, results_data)
        graph_parameters(parameters, :person_first_name, :person_last_name, :person_where)
        @search_for = 'person'
        GraphHelperLib.find_person_api_url(params[:person_first_name], params[:person_last_name], params[:person_where], api_key)
      elsif results_data.include? 'Business'
        @search_for = 'business'
        parameters = GraphHelperLib.business_parameters(response_json, results_data)
        graph_parameters(parameters, :business_name, :city, :state)
        GraphHelperLib.find_business_api_url(params[:business_name], params[:city], params[:state], api_key)
      end
    end
  end
end
