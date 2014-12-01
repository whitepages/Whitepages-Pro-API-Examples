module SearchFormHelper
  def parameters_form(url)
    str_params = url.to_s.split('json?').last
    params_arr = str_params.to_s.split('&')
    if url.include? 'location'
      parameters = GraphHelperLib.location_parameters(params_arr)
      graph_parameters(parameters, :address_street_line_1, :address_city)
      @search_for = 'location'
    elsif url.include? 'phone'
      parameters = GraphHelperLib.phone_parameters(params_arr)
      graph_parameters(parameters, :phone_number)
      @search_for = 'phone'
    elsif url.include? 'person'
      @search_for = 'person'
      parameters = GraphHelperLib.person_parameters(params_arr)
      graph_parameters(parameters, :person_first_name, :person_last_name, :person_where)
    elsif url.include? 'business'
      @search_for = 'business'
      parameters = GraphHelperLib.business_parameters(params_arr)
      graph_parameters(parameters, :business_name, :city, :state)
    end
  end
end
