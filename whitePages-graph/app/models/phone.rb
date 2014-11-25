class Phone
  attr_accessor :entity, :phone_number

  def initialize(entity)
    @entity = entity
    @phone_number = phone_number
  end

  def data
    {
        :phone_number => phone_number
    }
  end


  private


  def phone_number
    entity['phone_number']
  end
end