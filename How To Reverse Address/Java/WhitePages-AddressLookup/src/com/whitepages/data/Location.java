/**
 * This class contains the location details of Address Lookup data.
 * @author Kushal Shah
 * @since  2014-11-19
 */

package com.whitepages.data;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Location {
	// Location Data
	public final String addressLine1;
	public final String addressLine2;
	public final String addressLocation;
	public final boolean isReceivingMail;
	public final String usage;
	public final String deliveryPoint;
	public final Person[] personDataArray;

	/**
	 * Constructor of location class to Get location data related details from
	 * address lookup data.
	 * 
	 * @param dictionaryObject Dictionary object.
	 * @param locationObject Location object.
	 * @param locationKey Location key.
	 */
	Location(JSONObject dictionaryObject, JSONObject locationObject, String locationKey) throws JSONException {
		// Get addressLine1, addressLine2 and addressLocation from locationObject.
		this.addressLine1 = locationObject.optString("standard_address_line1");
		this.addressLine2 = locationObject.optString("standard_address_line2");
		this.addressLocation = locationObject.optString("standard_address_location");

		// Get isReceivingMail from locationObject.
		this.isReceivingMail = locationObject.optBoolean("is_receiving_mail");
		// Get usage from locationObject.
		this.usage = locationObject.optString("usage");
		// Get deliveryPoint from locationObject.
		this.deliveryPoint = locationObject.optString("delivery_point");

		// Get legalEntitiesAtArray from locationObject.
		JSONArray legalEntitiesAtArray = locationObject.getJSONArray("legal_entities_at");
		if (legalEntitiesAtArray != null && legalEntitiesAtArray.length() > 0) {
			this.personDataArray = new Person[legalEntitiesAtArray.length()];
			for (int i = 0; i < legalEntitiesAtArray.length(); i++) {
				JSONObject object = legalEntitiesAtArray.optJSONObject(i);
				if (object != null) {
					// Get idObject from object.
					JSONObject idObject = object.optJSONObject("id");
					if (idObject != null) {
						// Get personKey from idObject.
						String personKey = idObject.optString("key");
						if (personKey != null && !personKey.equals("")) {
							// Get the personObject from dictionaryObject using personKey.
							JSONObject personObject = dictionaryObject.optJSONObject(personKey);
							if (personObject != null) {
								// Call Person class constructor to get the person details.
								Person personData = new Person(personObject,locationKey);
								this.personDataArray[i] = personData;
							}
						}
					}
				}
			}
		} else {
			this.personDataArray = null;
		}
	}
}
