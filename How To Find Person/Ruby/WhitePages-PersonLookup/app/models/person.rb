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

  def person_address(id)
    best_location = retrieve_best_location_id(retrieve_by_id(id))
    entity_location = retrieve_by_id(best_location) if best_location
    ParseJsonResponse.address_details(entity_location)  if entity_location
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
