/**
 * This class contains people details of Phone Lookup data.
 * @author Kushal Shah
 * @since  2014-11-19
 */

package com.whitepages.data;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class People {
	// People Data
	public final String type;
	public final String name;
	public final Location locationData;
	
	/**
	 * Constructor of People class to get people data and related details from phone lookup data.
	 * @param dictionaryObject
	 * @param personKey
	 * @throws JSONException
	 */
	People(JSONObject dictionaryObject, String personKey) throws JSONException {
		// Get personObject from dictionaryObject.
		JSONObject personObject = dictionaryObject.optJSONObject(personKey);

		if (personObject != null) {
			// Get idObject from personObject.
			JSONObject idObject = personObject.optJSONObject("id");

			// Get type from idObject.
			this.type = idObject != null ? idObject.optString("type") : null;
			// Get name from personObject.
			this.name = personObject.has("best_name") ? personObject.optString("best_name")
					: (personObject.has("name") ? personObject.optString("name") : null);

			// Get personLocationObject from personObject.
			JSONObject personLocationObject = personObject.optJSONObject("best_location");
			if (personLocationObject == null) {
				// Get personLocationArray from personObject.
				JSONArray personLocationArray = personObject.getJSONArray("locations");
				personLocationObject = personLocationArray.optJSONObject(0);
			}

			// Get personIdObject from personLocationObject.
			JSONObject personIdObject = personLocationObject != null ? personLocationObject.optJSONObject("id") : null;

			// Get locationKey from personIdObject.
			String locationKey = personIdObject != null ? personIdObject.optString("key") : null;

			// Get locationObject from dictionaryObject.
			JSONObject locationObject = (locationKey != null && !locationKey
					.equals("")) ? dictionaryObject.optJSONObject(locationKey) : null;

			if (locationObject != null) {
				// Calling Location class constructor to get location data.
				this.locationData = new Location(locationObject);
			} else {
				this.locationData = null;
			}
		} else {
			// People Data
			this.type = null;
			this.name = null;
			this.locationData = null;
		}
	}
}
