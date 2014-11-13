class Result

  attr_accessor :json_response, :data_parse, :error, :person

  def initialize(json_response)
    @json_response = json_response
    @data_parse = data_parse
  end

  def data_parse
    unless json_response['error'].nil?
      @error = json_response['error']['message']
    else
      @person = json_response['results'].map do |id|
        person = Person.new(json_response['dictionary'][id])
        person.location(json_response,person.best_location)
        person.data
      end.reject(&:blank?)
    end
  end
end
