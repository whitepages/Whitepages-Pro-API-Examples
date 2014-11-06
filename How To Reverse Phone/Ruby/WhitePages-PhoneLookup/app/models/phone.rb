class Phone
  attr_reader :response
  def initialize(response)
    @response = response
  end

  def formatted_result
    response['results'].map do |entity| {
     phone: phone(entity),
     people: people(entity),
     location: location(entity)
    }end.reject(&:empty?)
  end


  private

  def retrieve_by_id(id)
    response['dictionary'][id] if id && response && response['dictionary'][id]
  end

  # get belongs to key
  def phone_belongs_to(id)
    entity = retrieve_by_id(id)
    entity['belongs_to'].map do |belongs_to_entity|
      belongs_to_entity['id']['key']
    end.reject(&:empty?)
  end

  # get best location key
  def phone_best_location(id)
    entity = retrieve_by_id(id)
    unless entity['best_location'].blank?
      entity['best_location']['id']['key']
    else
      entity['locations'].first['id']['key'] unless entity['locations'].blank?
    end
  end

  def phone_number(id)
    entity = retrieve_by_id(id)
    entity['phone_number']
  end

  def phone_country_code(id)
    entity = retrieve_by_id(id)
    entity['country_calling_code']
  end

  def phone_type(id)
    entity = retrieve_by_id(id)
    entity['line_type']
  end

  def phone_carrier(id)
    entity = retrieve_by_id(id)
    entity['carrier']
  end

  def do_not_call(id)
    entity = retrieve_by_id(id)
    entity['do_not_call']? 'Registered' : 'Not Registered'
  end

  def phone_reputation(id)
    entity = retrieve_by_id(id)
    entity['reputation']['spam_score'] if entity['reputation']
  end

  def phone_city(entity)
    entity['city']
  end

  def phone_state_code(entity)
    entity['state_code']
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

  def usage(entity)
    entity['usage']
  end

  def postal_code(entity)
    entity['postal_code']
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
     usage: usage(entity),
     delivery_point: delivery_point(entity),
     city: phone_city(entity),
     postal_code: postal_code(entity),
     state_code: phone_state_code(entity)
    }
  end

  # get belongs to location key
  def location(id)
    phone_belongs_to(id).map do |entity| {
     address: location_data(entity)
    } end.reject(&:empty?)
  end

  # get best location key and location details
  def location_data(id)
    location_id = phone_best_location(id)
    location = retrieve_by_id(location_id) if location_id
    location_details(location) if location
  end

  def people(id)
    phone_belongs_to(id).map do |entity| {
     name: people_name(entity),
     people_type: people_type(entity)
    }end.reject(&:empty?)
  end

  def people_name(id)
    entity = retrieve_by_id(id) if id
    entity['name'] || entity['best_name'] if entity
  end

  def people_type(id)
    entity = retrieve_by_id(id) if id
    entity['id']['type'] if entity
  end

  # get requested phone details
  def phone(entity)
    {
     number: phone_number(entity),
     country_code: phone_country_code(entity),
     phone_type: phone_type(entity),
     phone_carrier: phone_carrier(entity),
     do_not_call: do_not_call(entity),
     reputation: phone_reputation(entity)
    }
  end
end
