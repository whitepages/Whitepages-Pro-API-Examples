class Result

  attr_accessor :json_response, :data_parse, :error, :location

  def initialize(json_response)
    @json_response = json_response
    @data_parse = data_parse
  end

  def data_parse
    unless json_response['error'].nil?
      @error = json_response['error']['message']
    else
      @location = json_response['results'].map do |id|
        location = Location.new(json_response['dictionary'][id])
        location.legal_entities_at(json_response)
        location.data
      end.reject(&:blank?)
    end
  end
end
