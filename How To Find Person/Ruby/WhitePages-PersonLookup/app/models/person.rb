class Person
  def self.person_details(response)
    dictionary_data = response['dictionary']
    result_arr = Array.new
    unless dictionary_data.blank?
      response["results"].map { |result_key|
        data_hash = Hash.new
        data_hash["name"] = ParseJsonResponse.person_name(dictionary_data,result_key)
        data_hash["age"] = ParseJsonResponse.person_age(dictionary_data,result_key)
        data_hash["address"] = ParseJsonResponse.person_address(dictionary_data,result_key)
        data_hash["contact_type"] = ParseJsonResponse.person_contact_type(dictionary_data,result_key)
        result_arr << data_hash
      }
    end
    return result_arr
  end
end
