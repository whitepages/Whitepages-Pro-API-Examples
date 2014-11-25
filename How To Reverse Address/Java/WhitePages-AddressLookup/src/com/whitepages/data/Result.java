/**
 * This class contains the Address Lookup data.
 * @author Kushal Shah
 * @since  2014-06-08
 */

package com.whitepages.data;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Result {

	public Location locationData;
	public boolean isError = false;
	public String errorName = null;
	public String errorMessage = null;

	/**
	 * Constructor of Result class to parse error object.
	 * 
	 * @param errorObject: Error object.
	 */
	public Result(JSONObject errorObject) throws JSONException {
		this.isError = true;
		this.errorName = errorObject.optString("name");
		this.errorMessage = errorObject.optString("message");
		this.locationData = null;
	}

	/**
	 * Constructor of Result class to parse address data related details from
	 * address lookup data.
	 * 
	 * @param responseObject JSON response object.
	 * @param resultsArray Result array.
	 */
	public Result(JSONObject responseObject, JSONArray resultsArray) throws JSONException {
		// Get dictionaryObject.
		JSONObject dictionaryObject = responseObject.optJSONObject("dictionary");
		if (dictionaryObject != null) {
			String resultKey = resultsArray.optString(0);
			if (resultKey != null && !resultKey.equals("")) {
				// Get locationObject from dictionaryObject.
				JSONObject locationObject = dictionaryObject.optJSONObject(resultKey);
				if (locationObject != null) {
					// Call Location class constructor to get location details.
					this.locationData = new Location(dictionaryObject, locationObject, resultKey);
				}
			}
		} else {
			this.locationData = null;
		}
	}
}
