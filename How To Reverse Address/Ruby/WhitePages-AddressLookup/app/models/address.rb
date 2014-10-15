# This class handles for parse json for address api
class Address
  attr_reader :response
  def initialize(response)
    @response = response
  end

  def retrieve_by_id(id)
    response['dictionary'][id] if id && response && response['dictionary'][id]
  end

  def best_location_id(id)
    id['best_location']['id']['key'] if id && id['best_location'] && id['best_location']['id'] && id['id']['type'] == 'Person'
    id['locations'].first['id']['key'] if id && id['locations'] && id['id']['type'] != 'Person'
  end

  def person_name(id)
    entity = retrieve_by_id(id)
    entity['name'] || entity['best_name']
  end

  def person_age(id)
    entity = retrieve_by_id(id)
    entity['age_range']
  end

  def person_contact_type(id)
    entity = retrieve_by_id(id)
    entity['locations'].map do |locations_entity|
      locations_entity['contact_type']  if locations_entity['id']['key'] == best_location_id(entity)
    end.reject(&:nil?)
  end

  def persons(id)
    entity = retrieve_by_id(id)
    unless entity['legal_entities_at'].blank?
      entity['legal_entities_at'].map do |legal_entity|
        person_details(legal_entity['id']['key'])
      end.reject(&:nil?)
    end
  end

  def person_details(entity)
    {
     name: person_name(entity),
     age: person_age(entity),
     contact_type: person_contact_type(entity)
    }
  end

  def address_details(location)
    entity = retrieve_by_id(location)
    ParseJsonResponse.address_details(entity)  if entity
  end

  # formatted output
  def formatted_result
    response['results'].map do |entity|
      {
       address: address_details(entity),
       persons: persons(entity)
      }
    end.reject(&:empty?)
  end
end
