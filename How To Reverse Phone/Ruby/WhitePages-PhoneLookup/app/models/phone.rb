class Phone

  attr_accessor :entity, :line_type, :belongs_to, :associated_locations, :phone_number, :country_calling_code,
                :carrier, :do_not_call, :reputation, :best_location

  def initialize(entity)
    @entity = entity
    @line_type = line_type
    @belongs_to = belongs_to
    @associated_locations = associated_locations
    @phone_number = phone_number
    @country_calling_code = country_calling_code
    @carrier = carrier
    @do_not_call = do_not_call
    @reputation = reputation
    @best_location = best_location
  end

  def data
    {
     :line_type => line_type,
     :phone_number => phone_number,
     :country_calling_code => country_calling_code,
     :carrier => carrier,
     :do_not_call => do_not_call,
     :reputation => reputation
    }
  end

  def belongs_to
    entity['belongs_to'].map do |belongs_to|
      belongs_to['id']['key']
    end.reject(&:blank?)
  end


  private

  def phone_number
    entity['phone_number']
  end

  def line_type
    entity['line_type']
  end

  def associated_locations
    entity['associated_locations'].map do |location|
      location['id']['key']
    end.reject(&:blank?)
  end

  def country_calling_code
    entity['country_calling_code']
  end

  def carrier
    entity['carrier']
  end

  def reputation
    entity['reputation']['spam_score'] if entity['reputation']
  end

  def do_not_call
    entity['do_not_call']? 'Registered' : 'Not Registered'
  end

  def best_location
    entity['best_location']['id']['key'] if entity && entity['best_location'] && entity['best_location']['id']
  end
end
