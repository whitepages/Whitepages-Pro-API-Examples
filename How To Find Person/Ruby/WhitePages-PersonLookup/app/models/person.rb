class Person
  attr_reader :response
  def initialize(response)
    @response = response
  end

  def retrieve_by_id(id)
    response['dictionary'][id] if id && response && response['dictionary'][id]
  end

  def retrieve_best_location_id(id)
    id['best_location']['id']['key'] if id && id['best_location'] && id['best_location']['id']
  end

  def person_name(id)
    entity = retrieve_by_id(id)
    entity['name'] || entity['best_name']
  end

  def person_age(id)
    entity = retrieve_by_id(id)
    entity['age_range']
  end

  def standard_address_line1(entity)
    entity['standard_address_line1']
  end

  def standard_address_line2(entity)
    entity['standard_address_line2']
  end

  def receiving_mail(entity)
    entity['is_receiving_mail']? 'Yes' : 'No'
  end

  def city(entity)
    entity['city']
  end

  def postal_code(entity)
    entity['postal_code']
  end

  def state_code(entity)
    entity['state_code']
  end

  def usage(entity)
    entity['usage']
  end

  def delivery_point(entity)
    entity['delivery_point']
  end

  # get location details
  def location_details(entity)
    {
     standard_address_line1: standard_address_line1(entity),
     standard_address_line2: standard_address_line2(entity),
     receiving_mail: receiving_mail(entity),
     postal_code: postal_code(entity),
     usage: usage(entity),
     delivery_point: delivery_point(entity),
     city: city(entity),
     state_code: state_code(entity)
    }
  end

  def location(id)
    location = retrieve_by_id(id)
    location_details(location) if location
  end

  def person_address(id)
    best_location = retrieve_best_location_id(retrieve_by_id(id))
    location(best_location) if best_location 
  end

  def person_contact_type(id)
    entity = retrieve_by_id(id)
    entity['locations'].map do |locations_entity|
      locations_entity['contact_type']  if locations_entity['id']['key'] == retrieve_best_location_id(entity)
    end.reject(&:nil?)
  end

  def formatted_result
    response['results'].map do |entity|
      {
       name: person_name(entity),
       age: person_age(entity),
       contact_type: person_contact_type(entity),
       address: person_address(entity)
      }
    end.reject(&:empty?)
  end
end
