# This class handles for parse json for address api
class Address
  attr_reader :response

  def initialize(response)
    @response = response
  end

  # formatted output
  def formatted_result
    response['results'].map do |entity|
      {
       address: address(entity),
       persons: persons(entity)
      }
    end.reject(&:empty?)
  end


  private

  def retrieve_by_id(id)
    response['dictionary'][id] if id && response && response['dictionary'][id]
  end

  def best_location_id(id)
    if id['best_location'] && id['best_location']['id'] && id['id']['type'] == 'Person'
      id['best_location']['id']['key']
    else
      id['locations'].first['id']['key'] unless id['locations'].blank?
    end
  end

  def address(id)
    location = retrieve_by_id(id)
    location_details(location) if location
  end

 # get people contact type
  def contact_type(entity)
    entity['locations'].map do |locations_entity|
      locations_entity['contact_type']  if locations_entity['id']['key'] == best_location_id(entity)
    end.reject(&:nil?)
  end

 # get people details array
  def persons(id)
    entity = retrieve_by_id(id)
    unless entity['legal_entities_at'].blank?
      entity['legal_entities_at'].map do |legal_entity|
        people_details(legal_entity['id']['key'])
      end.reject(&:nil?)
    end
  end

  # get people details
  def people_details(id)
    entity = retrieve_by_id(id)
    {
     name: entity['name'] || entity['best_name'],
     age: entity['age_range'],
     contact_type: contact_type(entity)
    }
  end

  # get location details
  def location_details(entity)
    {
     standard_address_line1: entity['standard_address_line1'],
     standard_address_line2: entity['standard_address_line2'],
     receiving_mail: entity['is_receiving_mail']? 'Yes' : 'No',
     usage: entity['usage'],
     delivery_point: entity['delivery_point'],
     postal_code: entity['postal_code'],
     city: entity['city'],
     state_code: entity['state_code']
    }
  end
end
