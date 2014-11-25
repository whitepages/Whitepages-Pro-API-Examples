class Person

  attr_accessor :entity, :best_location, :first_name, :last_name

  def initialize(entity)
    @entity = entity
    @first_name = first_name
    @last_name = last_name
    @best_location = best_location
  end

  def data
    {
        :first_name => first_name,
        :last_name => last_name,
        :best_location => best_location
    }
  end

  private



  def best_location
    if entity['best_location']
      entity['best_location']['id']['key']
    else
      entity['locations'].first['id']['key'] unless entity['locations'].blank?
    end
  end

  def first_name
    entity['names'].first['first_name']  if entity['names']
  end

  def last_name
    entity['names'].first['last_name']  if entity['names']
  end
end
