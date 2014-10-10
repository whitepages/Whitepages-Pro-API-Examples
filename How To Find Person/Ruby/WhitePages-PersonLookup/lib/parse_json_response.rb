module ParseJsonResponse
#method for person name
  def self.person_name(dictionaryData,result_key)
    name = ""
    unless dictionaryData[result_key].blank?
      entity_type =  dictionaryData[result_key]["id"]["type"]
      if entity_type == "Person"
        name = dictionaryData[result_key]["best_name"].blank? ? "" : dictionaryData[result_key]["best_name"]
      end
    end
    return name
  end

#method for person age
  def self.person_age(dictionaryData,result_key)
    age = ""
    unless dictionaryData[result_key].blank?
      entity_type =  dictionaryData[result_key]["id"]["type"]
      if entity_type == "Person"
        age =  dictionaryData[result_key]["age_range"].blank? ? "" : dictionaryData[result_key]["age_range"]["start"].to_s + "+"
      end
    end
    return age
  end

#method for address details
  def self.person_address(dictionaryData,result_key)
    address_hash = Hash.new
    unless dictionaryData[result_key].blank?
      unless dictionaryData[result_key]["best_location"].blank?
        location_key = dictionaryData[result_key]["best_location"]["id"]["key"]
        address_hash["city"] =  dictionaryData[location_key]["city"]
        address_hash["postal_code"]=  dictionaryData[location_key]["postal_code"]
        address_hash["standard_address_line1"]=  dictionaryData[location_key]["standard_address_line1"]
        address_hash["standard_address_line2"]= dictionaryData[location_key]["standard_address_line2"]
        address_hash["standard_address_location"]=  dictionaryData[location_key]["standard_address_location"]
        address_hash["usage"]= dictionaryData[location_key]["usage"]
        address_hash["delivery_point"]= dictionaryData[location_key]["delivery_point"]
        address_hash["is_receiving_mail"] = dictionaryData[location_key]["is_receiving_mail"]== false ? "No" : "Yes"
      end
    end
    return address_hash
  end

#method for contact type details
  def self.person_contact_type(dictionaryData,result_key)
    contact_type = ""
    unless dictionaryData[result_key].blank?
      unless dictionaryData[result_key]["best_location"].blank?
        location_key = dictionaryData[result_key]["best_location"]["id"]["key"]
        unless dictionaryData[result_key]["locations"].blank?
          dictionaryData[result_key]["locations"].map { |locations|
            if locations["id"]["key"] == location_key
              contact_type = locations["contact_type"]
            end
          }
        end
      end
    end
    return contact_type
  end

end