/**
 * This is the class contains method parsePhoneLookupData to parse the result.
 * @author Kushal Shah
 * @since  2014-06-08
 */

package com.whitepages.utilities;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.whitepages.data.Result;

public class PhoneLookupParser {

	/**
	 * This method parse the phone lookup response to Result.
	 * 
	 * @param phoneLookupJsonResponse Phone lookup JSON response.
	 * @return: Result.
	 */
	public Result parsePhoneLookupData(String phoneLookupJsonResponse) {
		Result resultData = null;
		try {
			JSONObject responseObject = new JSONObject(phoneLookupJsonResponse);
			if (responseObject != null) {
				if (responseObject.has("results")) {
					JSONArray resultsArray = responseObject.optJSONArray("results");
					if (resultsArray != null && resultsArray.length() > 0) {
						resultData = new Result(responseObject, resultsArray);
					}
				} else if (responseObject.has("error")) {
					JSONObject errorObject = responseObject.optJSONObject("error");
					if (errorObject != null) {
						resultData = new Result(errorObject);
					}
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}

		return resultData;
	}
}
