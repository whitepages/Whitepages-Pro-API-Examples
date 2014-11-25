class Business

  attr_accessor :entity, :best_location, :name

  def initialize(entity)
    @entity = entity
    @name = name
    @best_location = best_location
  end

  def data
    {
        :name => name,
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

  def name
    entity['name']
  end
end
