class Location

  attr_accessor :entity, :city, :postal_code, :state_code, :country_code,
                :is_receiving_mail, :usage, :delivery_point, :is_deliverable, :standard_address_line1, :standard_address_line2

  def initialize(entity)
    @entity = entity
    @city = city
    @postal_code = postal_code
    @state_code = state_code
    @country_code = country_code
    @is_receiving_mail = is_receiving_mail
    @usage = usage
    @delivery_point = delivery_point
    @is_deliverable = is_deliverable
    @standard_address_line1 = standard_address_line1
    @standard_address_line2 = standard_address_line2
  end

  def data
    {
     :city => city,
     :postal_code => postal_code,
     :state_code => state_code,
     :country_code => country_code,
     :is_receiving_mail => is_receiving_mail,
     :usage => usage,
     :delivery_point => delivery_point,
     :is_deliverable => is_deliverable,
     :standard_address_line1 => standard_address_line1,
     :standard_address_line2 => standard_address_line2
    }
  end

  private

  def city
    entity['city']
  end

  def postal_code
    entity['postal_code']
  end

  def state_code
    entity['state_code']
  end

  def country_code
    entity['country_code']
  end

  def is_receiving_mail
    entity['is_receiving_mail']
  end

  def is_deliverable
    entity['is_deliverable']
  end

  def delivery_point
    entity['delivery_point']
  end

  def usage
    entity['usage']
  end

  def standard_address_line1
    entity['standard_address_line1']
  end

  def standard_address_line2
    entity['standard_address_line2']
  end
end
