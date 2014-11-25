/**
 * This class contains the Phone Lookup data.
 * @author Kushal Shah
 * @since  2014-06-08
 */

package com.whitepages.data;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Result {
	public Phone[] phoneDataArary;
	public boolean isError = false;
	public String errorName = null;
	public String errorMessage = null;
	
	/**
	 * Constructor of Result class to parse error object.
	 * @param errorObject
	 * @throws JSONException
	 */
	public Result(JSONObject errorObject) throws JSONException {
		this.isError = true;
		this.errorName = errorObject.optString("name");
		this.errorMessage = errorObject.optString("message");
		this.phoneDataArary = null;
	}
	
	/**
	 * Constructor of Result class to parse phone related details from phone lookup data.
	 * @param responseObject JSON response object.
	 * @param resultsArray Result array.
	 * @throws JSONException
	 */
	public Result(JSONObject responseObject, JSONArray resultsArray) throws JSONException {
		this.phoneDataArary = new Phone[resultsArray.length()];

		// Get dictionaryObject from responseObject.
		JSONObject dictionaryObject = responseObject.optJSONObject("dictionary");
		if (dictionaryObject != null) {
			for (int i = 0; i < resultsArray.length(); i++) {
				String resultKey = resultsArray.optString(i);
				if (resultKey != null && !resultKey.equals("")) {
					// Get phoneObject from dictionaryObject.
					JSONObject phoneObject = dictionaryObject.optJSONObject(resultKey);
					if (phoneObject != null) {
						// Calling Phone class constructor to get phone data.
						Phone phoneData = new Phone(dictionaryObject, phoneObject);
						this.phoneDataArary[i] = phoneData;
					}
				}
			}
		} else {
			this.phoneDataArary = null;
		}
	}
}
