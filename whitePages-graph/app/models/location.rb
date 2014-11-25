class Location

  attr_accessor :entity, :city, :postal_code, :state_code,  :zip4, :standard_address_line1

  def initialize(entity)
    @entity = entity
    @city = city
    @postal_code = postal_code
    @state_code = state_code
    @standard_address_line1 = standard_address_line1
    @zip4 = zip4
  end

  def data
    {
        :city => city,
        :postal_code => postal_code,
        :state_code => state_code,
        :zip4 => zip4,
        :standard_address_line1 => standard_address_line1
    }
  end


  private

  def city
    entity['city']
  end

  def postal_code
    entity['postal_code']
  end

  def zip4
    entity['zip4']
  end

  def state_code
    entity['state_code']
  end

  def standard_address_line1
    entity['standard_address_line1']
  end
end
