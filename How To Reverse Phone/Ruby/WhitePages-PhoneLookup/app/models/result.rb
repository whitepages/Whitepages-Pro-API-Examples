class Result

  attr_accessor :json_response, :data_parse, :error, :phone, :people, :location

  def initialize(json_response)
    @json_response = json_response
    @data_parse = data_parse
  end

  def data_parse
    unless json_response['error'].nil?
      @error = json_response['error']['message']
    else
      json_response['results'].map do |id|
        phone = Phone.new(json_response['dictionary'][id])
        belongs_to = phone.belongs_to
        @phone = phone.data
        unless belongs_to.blank?
          @people = belongs_to.map do |belongs_to_id|
            Person.new(json_response['dictionary'][belongs_to_id]).data
          end.reject(&:blank?)
          @location = belongs_to.map do |belongs_to_id|
            best_location = Person.new(json_response['dictionary'][belongs_to_id]).best_location
            Location.new(json_response['dictionary'][best_location]).data if best_location
          end.reject(&:blank?)
        end
      end.reject(&:blank?)
    end
  end
end
