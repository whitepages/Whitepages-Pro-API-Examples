/**
 * This class contains the person details of Address Lookup data.
 * @author Kushal Shah
 * @since  2014-11-19
 */

package com.whitepages.data;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Person {
	// person Data
	public final String name;
	public final String contactType;

	/**
	 * Constructor of Person class to Get person data related details from
	 * address lookup data.
	 * 
	 * @param dictionaryObject Dictionary object.
	 * @param locationObject Location object.
	 * @param locationKey Location key.
	 */
	Person(JSONObject personObject, String locationKey) throws JSONException {
		// Get person name
		this.name = personObject.has("best_name") ? personObject.optString("best_name"):
			(personObject.has("name") ? personObject.optString("name"): null);

		// Get contactType
		String contactType = "";

		// Get locationArray from personObject.
		JSONArray locationArray = personObject.optJSONArray("locations");
		if (locationArray != null && locationArray.length() > 0) {
			for (int i = 0; i < locationArray.length(); i++) {
				JSONObject object = locationArray.optJSONObject(i);
				if (object != null) {
					// Get locationIdObject from object.
					JSONObject locationIdObject = object.optJSONObject("id");
					if (locationIdObject != null) {
						// Get actualLocationKey from locationIdObject.
						String actualLocationKey = locationIdObject.optString("key");
						if (locationKey.equals(actualLocationKey)) {
							// Get contactType from object.
							contactType = object.optString("contact_type");
							break;
						}
					}
				}
			}
		}
		this.contactType = contactType;
	}
}
