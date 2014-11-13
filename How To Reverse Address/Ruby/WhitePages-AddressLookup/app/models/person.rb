class Person

  attr_accessor :entity, :name, :age_range, :type

  def initialize(entity)
    @entity = entity
    @name = name
    @type = type
    @age_range = age_range
  end

  def data
    {
     :name => name,
     :type => type,
     :age_range => age_range
    }
  end


  private

  def name
    entity['name'] || entity['best_name']
  end

  def type
    entity['id']['type']  unless entity['id'].blank?
  end

  def age_range
    entity['age_range']
  end
end
