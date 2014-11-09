class Person
  attr_reader :response
  def initialize(response)
    @response = response
  end

  def formatted_result
    response['results'].map do |id|
      entity = retrieve_by_id(id)
      {
       name: entity['name'] || entity['best_name'],
       age: entity['age_range'],
       contact_type: contact_type(entity),
       address: address(entity)
      }
    end.reject(&:empty?)
  end


  private

  def retrieve_by_id(id)
    response['dictionary'][id] if id && response && response['dictionary'][id]
  end

  def best_location_id(id)
    id['best_location']['id']['key'] if id && id['best_location'] && id['best_location']['id']
  end

  def location(id)
    location = retrieve_by_id(id)
    location_details(location) if location
  end

  def address(entity)
    best_location = best_location_id(entity)
    location(best_location) if best_location
  end

  def contact_type(entity)
    entity['locations'].map do |locations_entity|
      locations_entity['contact_type']  if locations_entity['id']['key'] == best_location_id(entity)
    end.reject(&:nil?)
  end

  # get location details
  def location_details(entity)
    {
     standard_address_line1: entity['standard_address_line1'],
     standard_address_line2: entity['standard_address_line2'],
     receiving_mail: entity['is_receiving_mail']? 'Yes' : 'No',
     postal_code: entity['postal_code'],
     usage: entity['usage'],
     delivery_point: entity['delivery_point'],
     city: entity['city'],
     state_code: entity['state_code']
    }
  end
end
