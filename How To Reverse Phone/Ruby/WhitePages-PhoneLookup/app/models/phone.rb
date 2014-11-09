class Phone
  attr_reader :response

  def initialize(response)
    @response = response
  end

  # return formatted result array
  def formatted_result
    response['results'].map do |entity| {
     phone: phone_detail(entity),
     people: people_detail(entity),
     location: location_detail(entity)
    }end.reject(&:empty?)
  end


  private

  # get belongs to location key
  def location_detail(phone_key)
    location_arr =  belongs_to_best_location(phone_key)
    if location_arr.blank?
      location_arr << best_location(phone_key) if best_location(phone_key)
    end
    location_arr = location_arr.uniq

    location_arr.map do |entity| {
     address: location_data(entity)
    } end.reject(&:empty?)
  end

  # get belongs to key
  def belongs_to_best_location(id)
    entity = retrieve_by_id(id)
    entity['belongs_to'].map do |entity|
      best_location(entity['id']['key'])
    end.reject(&:blank?)
  end

  def belongs_to_people(id)
    entity = retrieve_by_id(id)
    entity['belongs_to'].map do |entity|
      entity['id']['key']
    end.reject(&:blank?)
  end

  # for getting object from id
  def retrieve_by_id(id)
    response['dictionary'][id] if id && response && response['dictionary'][id]
  end

  # get best location key
  def best_location(id)
    entity = retrieve_by_id(id)
    unless entity['best_location'].blank?
      entity['best_location']['id']['key']
    else
      entity['locations'].first['id']['key'] unless entity['locations'].blank?
    end
  end

  # phone spam score
  def reputation(entity)
    entity['reputation']['spam_score'] if entity['reputation']
  end

  # getting location details using location id
  def location_data(id)
    entity = retrieve_by_id(id)
    {
     standard_address_line1: entity['standard_address_line1'],
     standard_address_line2: entity['standard_address_line2'],
     receiving_mail: entity['is_receiving_mail']? 'Yes' : 'No',
     usage: entity['usage'],
     delivery_point: entity['delivery_point'],
     city: entity['city'],
     postal_code: entity['postal_code'],
     state_code: entity['state_code']
    }
  end

  # getting people details using people id
  def people_detail(id)
    belongs_to_people(id).map do |people_entity|
      entity = retrieve_by_id(people_entity)
      {
       name: entity['name'] || entity['best_name'],
       people_type: entity['id']['type']
      }end.reject(&:empty?)
  end

  # getting phone details using phone id
  def phone_detail(id)
    entity = retrieve_by_id(id)
    {
     number: entity['phone_number'],
     country_code: entity['country_calling_code'],
     phone_type: entity['line_type'],
     phone_carrier: entity['carrier'],
     do_not_call: entity['do_not_call']? 'Registered' : 'Not Registered',
     reputation: reputation(entity)
    }
  end
end
