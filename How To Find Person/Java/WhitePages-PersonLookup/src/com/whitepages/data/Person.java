/**
 * This class contains the person details of Person Lookup data.
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
	public final String ageRange;
	public final String contactType;
	public final Location locationData;
	
	/**
	 * Constructor of Person class to Get person data related details from person lookup data.
	 * @param dictionaryObject Dictionary object
	 * @param personObject Person object.
	 * @throws JSONException
	 */
	Person(JSONObject dictionaryObject, JSONObject personObject) throws JSONException {
		// Get age range
		JSONObject ageRangeObject = personObject.optJSONObject("age_range");
		if (ageRangeObject != null) {
			String age = ageRangeObject.optString("start");
			if (age != null && !age.equals("")) {
				this.ageRange = age + "+";
			} else {
				this.ageRange = null;
			}
		} else {
			this.ageRange = null;
		}

		// Get person name
		this.name = personObject.has("best_name") ? personObject.optString("best_name")
				: (personObject.has("name") ? personObject.optString("name") : null);

		// Get contactType
		String actualLocationKey = "";
		String contactType = "";
		// Get personBestLocationObject from personObject.
		JSONObject personBestLocationObject = personObject.optJSONObject("best_location");
		if (personBestLocationObject != null) {
			JSONObject idObject = personBestLocationObject.optJSONObject("id");
			if (idObject != null) {
				// Get actualLocationKey from idObject.
				actualLocationKey = idObject.optString("key");

				// Get locationArray from personObject.
				JSONArray locationArray = personObject.optJSONArray("locations");
				if (locationArray != null && locationArray.length() > 0) {
					for (int i = 0; i < locationArray.length(); i++) {
						JSONObject object = locationArray.optJSONObject(i);
						if (object != null) {
							// Get locationIdObject.
							JSONObject locationIdObject = object.optJSONObject("id");
							if (locationIdObject != null) {
								// Get locationKey from locationIdObject.
								String locationKey = locationIdObject.optString("key");
								if (locationKey.equals(actualLocationKey)) {
									// Get contactType.
									contactType = object.optString("contact_type");
									break;
								}
							}
						}
					}
				}
			}
		} else {
			// Get locationArray from personObject.
			JSONArray locationArray = personObject.optJSONArray("locations");
			if (locationArray != null && locationArray.length() > 0) {
				JSONObject object = locationArray.optJSONObject(0);
				if (object != null) {
					// Get contactType.
					contactType = object.optString("contact_type");
					// Get locationIdObject.
					JSONObject locationIdObject = object.optJSONObject("id");
					if (locationIdObject != null) {
						// Get actualLocationKey from locationIdObject.
						actualLocationKey = locationIdObject.optString("key");
					}
				}
			}
		}

		this.contactType = contactType;

		// Get locationObject from dictionaryObject.
		JSONObject locationObject = (actualLocationKey != null && !actualLocationKey
				.equals("")) ? dictionaryObject.optJSONObject(actualLocationKey) : null;

		if (locationObject != null) {
			// Calling Location class constructor to get location data.
			this.locationData = new Location(locationObject);
		} else {
			this.locationData = null;
		}
	}
}
