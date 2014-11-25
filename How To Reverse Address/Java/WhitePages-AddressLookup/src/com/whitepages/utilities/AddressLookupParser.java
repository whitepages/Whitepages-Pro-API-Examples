/**
 * This is the class contains method parseAddressLookupData to parse the result.
 * @author Kushal Shah
 * @since  2014-06-08
 */

package com.whitepages.utilities;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.whitepages.data.Result;

public class AddressLookupParser {

	/**
	 * This method parse the address lookup response to Result.
	 * 
	 * @param addressLookupJsonResponse address lookup JSON response.
	 * @return Result.
	 */
	public Result parseAddressLookupData(String addressLookupJsonResponse) {
		Result addressLookupData = null;
		try {
			// Creating responseObject.
			JSONObject responseObject = new JSONObject(addressLookupJsonResponse);
			if (responseObject != null) {
				if (responseObject.has("results")) {
					JSONArray resultsArray = responseObject.optJSONArray("results");
					if (resultsArray != null && resultsArray.length() > 0) {
						// Calling Result constructor to get address lookup data.
						addressLookupData = new Result(responseObject, resultsArray);
					}
				} else if (responseObject.has("error")) {
					JSONObject errorObject = responseObject.optJSONObject("error");
					if (errorObject != null) {
						addressLookupData = new Result(errorObject);
					}
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}

		return addressLookupData;
	}
}
