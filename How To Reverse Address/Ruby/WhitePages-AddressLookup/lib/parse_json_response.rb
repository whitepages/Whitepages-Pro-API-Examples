# This module parse data for address details.
module ParseJsonResponse
  def self.address_details(location_id)
    address_hash = {}
    unless location_id.blank?
      address_hash['city'] = location_id['city']
      address_hash['postal_code'] = location_id['postal_code']
      address_hash['standard_address_line1'] = location_id['standard_address_line1']
      address_hash['standard_address_line2'] = location_id['standard_address_line2']
      address_hash['standard_address_location'] = location_id['standard_address_location']
      address_hash['usage'] = location_id['usage']
      address_hash['delivery_point'] = location_id['delivery_point']
      address_hash['is_receiving_mail'] = location_id['is_receiving_mail'] == false ? 'No' : 'Yes'
    end
    address_hash
  end
end