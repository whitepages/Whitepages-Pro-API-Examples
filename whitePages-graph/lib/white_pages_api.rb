require 'uri'

class WhitePagesApi

  def initialize(params, api_key)
    @api_version = '2.0'
    @base_uri = 'https://proapi.whitepages.com/'
    @params = params.merge({ :api_key => api_key })
    @reverse_phone_uri = reverse_phone_uri
  end

  def reverse_phone_uri
    @base_uri + @api_version + '/phone.json?' + hash_to_query(@params)
  end

  def reverse_address_uri
    @base_uri + @api_version + '/location.json?' + hash_to_query(@params)
  end

  def find_person_uri
    @base_uri + @api_version + '/person.json?' +hash_to_query(@params)
  end

  def find_business_uri
    @base_uri + @api_version + '/business.json?' + hash_to_query(@params)
  end

  private


  def hash_to_query(hash)
    return hash.map{|k,v| "#{k}=#{URI.encode(v.gsub(/[& #]/, ' '))}"}.join("&")
  end
end