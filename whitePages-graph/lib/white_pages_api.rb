require 'uri'
class WhitePagesApi
  attr_accessor :phone,:business_name, :city,:state,:street_line_1,:first_name, :last_name, :address
  def initialize(api_key)
    @api_key=api_key
    @base_uri = "https://proapi.whitepages.com/2.0/"
    @find_business_uri = @base_uri + "business.json?"
    @find_phone_uri = @base_uri + "phone.json?"
    @find_person_uri = @base_uri + "person.json?"
    @find_location_uri = @base_uri + "location.json?"
  end

  def get_phone_url
    build_uri(@phone,'','', "phone")
  end

  def get_business_url
    build_uri(@business_name,@city,@state, "business")
  end

  def get_location_url
    build_uri(@street_line_1,@city,'', "location")
  end

  def get_person_url
    build_uri(@first_name,@last_name,@address, "person")
  end

  private
 #Build the appropriate URL
  def build_uri(value1,value12,value13, type)
    case type
      when "business"
        built_uri = @find_business_uri + "name=#{value1}&city=#{value12}&state=#{value13}"
      when "phone"
        built_uri = @find_phone_uri + "phone=#{value1}"
      when "person"
        built_uri = @find_person_uri + "first_name=#{value1}&last_name=#{value12}&address=#{value13}"
      when "location"
        built_uri = @find_location_uri + "street_line_1=#{value1}&city=#{value12}"
    end
    built_uri = built_uri + "&api_key=" + @api_key
    return URI.escape(built_uri)
  end

end