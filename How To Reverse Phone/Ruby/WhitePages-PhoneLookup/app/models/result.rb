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
        # get phone data and people ids from belongs to
        belongs_to = phone.belongs_to
        @phone = phone.data
        # get location data from phone best location id. if belongs to location id is blank.
        if belongs_to.blank?
          @location = [Location.new(json_response['dictionary'][phone.best_location]).data] if phone.best_location
        else
          # get people data and store best location ids in temp_locations array
          temp_locations = Array.new
          @people = belongs_to.map do |belongs_to_id|
            person_location = Person.new(json_response['dictionary'][belongs_to_id]).best_location
            temp_locations << person_location if person_location
            Person.new(json_response['dictionary'][belongs_to_id]).data
          end.reject(&:blank?)
          # get location data from phone best location id. if belongs to location id is blank.
          if temp_locations.blank?
            @location = [Location.new(json_response['dictionary'][phone.best_location]).data] if phone.best_location
          else
            # get location data by belongs_to best location key.
            @location = temp_locations.uniq.map do |location_id|
              Location.new(json_response['dictionary'][location_id]).data
            end.reject(&:blank?)
          end
        end
      end.reject(&:blank?)
    end
  end
end
