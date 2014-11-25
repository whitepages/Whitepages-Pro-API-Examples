/**
 * This class contains the Person Lookup data.
 * @author Kushal Shah
 * @since  2014-11-19
 */

package com.whitepages.data;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Result {

	public Person[] personDataArary;
	public boolean isError = false;
	public String errorName = null;
	public String errorMessage = null;
	
	/**
	 * Constructor of Result class to parse error object.
	 * @param errorObject Error object.
	 * @throws JSONException
	 */
	public Result(JSONObject errorObject) throws JSONException {
		this.isError = true;
		this.errorName = errorObject.optString("name");
		this.errorMessage = errorObject.optString("message");
		this.personDataArary = null;
	}
	
	/**
	 * Constructor of Result class to parse person data related details from person lookup data.
	 * @param responseObject JSON response object.
	 * @param resultsArray Result array.
	 * @throws JSONException
	 */
	public Result(JSONObject responseObject, JSONArray resultsArray) throws JSONException {
		this.personDataArary = new Person[resultsArray.length()];

		// Get dictionaryObject from responseObject.
		JSONObject dictionaryObject = responseObject.optJSONObject("dictionary");
		if (dictionaryObject != null) {
			for (int i = 0; i < resultsArray.length(); i++) {
				String resultKey = resultsArray.optString(i);
				if (resultKey != null && !resultKey.equals("")) {
					// Get personObject from dictionaryObject.
					JSONObject personObject = dictionaryObject.optJSONObject(resultKey);
					if (personObject != null) {
						// Calling Person class constructor to get person data.
						Person personData = new Person(dictionaryObject, personObject);
						this.personDataArary[i] = personData;
					}
				}
			}
		} else {
			this.personDataArary = null;
		}
	}
}
