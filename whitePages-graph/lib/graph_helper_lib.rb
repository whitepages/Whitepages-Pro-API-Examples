require 'white_pages_api'
require 'graph'
require 'cipher'

module GraphHelperLib

  def self.location_address(location, address = '')
    address =  address + location[:city] + ', ' unless location[:city].nil?
    address = address + location[:state_code] + ' '  unless location[:state_code].nil?
    address = address + location[:postal_code]  unless location[:postal_code].nil?
    address =  address + '-' + location[:zip4]  unless location[:zip4].nil?
    return address
  end

  def self.person_address(location, person_address = '')
    person_address =  person_address + location[:standard_address_line1] + ' ' unless location[:standard_address_line1].nil?
    person_address =  location_address(location)
    return person_address
  end

  def self.encrypt(api_key, session_key)
    cipher = Cipher.new()
    encrypt_key = cipher.encrypt api_key
    if session_key.blank?
      return encrypt_key
    else
      if encrypt_key == session_key
        return session_key
      else
        return  encrypt_key
      end
    end
  end

  def self.create_svg(key, url)
    graph_name = 'graph_search_' + key +  '.svg'
    Graph.create_svg(URI.unescape(url),graph_name)
  end

  def self.find_business_api_url(name, city, state, api_key)
    req_params = { :name => name,
                   :city => city,
                   :state => state }
    WhitePagesApi.new(req_params, api_key).find_business_uri
  end

  def self.find_person_api_url(first_name, last_name, where, api_key)
    req_params = { :first_name => first_name,
                   :last_name => last_name,
                   :address => where }
    WhitePagesApi.new(req_params, api_key).find_person_uri
  end

  def self.reverse_address_api_url(street_line_1, city, api_key)
    req_params = { :street_line_1 => street_line_1,
                   :city => city }
    WhitePagesApi.new(req_params, api_key).reverse_address_uri
  end

  def self.reverse_phone_api_url(phone, api_key)
    req_params = { :phone => phone }
    WhitePagesApi.new(req_params, api_key).reverse_phone_uri
  end

  def self.location_parameters(params, data='')
    if data.blank?
      standard_address_line1 = URI.unescape(params[0].to_s.split('=').last)
      address_city =  URI.unescape(params[1].to_s.split('=').last)
    else
      location = Location.new(params['dictionary'][data]).data
      standard_address_line1 = location[:standard_address_line1]
      address_city =  GraphHelperLib.location_address(location)
    end
    { :address_street_line_1 => standard_address_line1,
      :address_city => address_city }
  end

  def self.phone_parameters(params, data='')
    if data.blank?
      phone_number = URI.unescape(params[0].to_s.split('=').last)
    else
      phone_number =  Phone.new(params['dictionary'][data]).data[:phone_number]
    end
    { :phone_number => phone_number }
  end

  def self.person_parameters(params, data='')
    if data.blank?
      first_name= URI.unescape(params[0].to_s.split('=').last)
      last_name =  URI.unescape(params[1].to_s.split('=').last)
      where =  URI.unescape(params[2].to_s.split('=').last)
    else
      where = ''
      person = Person.new(params['dictionary'][data]).data
      first_name  = person[:first_name]
      last_name = person[:last_name]
      best_location = person[:best_location]
      unless best_location.blank?
        where = GraphHelperLib.person_address(Location.new(params['dictionary'][best_location]).data)
      end
    end
    { :person_first_name => first_name,
      :person_last_name => last_name,
      :person_where => where }
  end

  def self.business_parameters(params, data='')
    if data.blank?
      business_name = URI.unescape(params[0].to_s.split('=').last)
      city  = URI.unescape(params[1].to_s.split('=').last)
      state = URI.unescape(params[2].to_s.split('=').last)
    else
      city, state = '', ''
      business = Business.new(params['dictionary'][data]).data
      business_name = business[:name]
      best_location = business[:best_location]
      unless best_location.blank?
        location = Location.new(params['dictionary'][best_location]).data
        city =  location[:city]
        state = location[:state_code]
      end
    end
    { :business_name => business_name,
      :city => city,
      :state =>state }
  end

end