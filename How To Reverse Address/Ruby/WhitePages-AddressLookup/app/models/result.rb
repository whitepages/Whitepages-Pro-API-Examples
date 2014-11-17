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
        legal_entities_arr = location.legal_entities_at
        unless legal_entities_arr.blank?
            location.legal_entities = legal_entities_arr.map do |legal_entity_id|
               Person.new(json_response['dictionary'][legal_entity_id]).data
            end
        end
        location.data
      end.reject(&:blank?)
    end
  end
end
