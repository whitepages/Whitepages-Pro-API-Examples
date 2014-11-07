/**
 * This is the class contains method parsePersonAdressLookupData to parse the result.
 * @author Kushal Shah
 * @since  2014-06-08
 */

package com.whitepages.utilities;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.whitepages.data.PersonAddressLookupData;

public class PersonAddressLookupParser {

	/**
	 * This method parse the person lookup response to PersonAddressLookupData.
	 * @param personAddressLookupJsonResponse: person lookup JSON response.
	 * @return: PersonAddressLookupData.
	 */
	public PersonAddressLookupData parsePersonAdressLookupData(String personAddressLookupJsonResponse) {
		PersonAddressLookupData personAddressLookupData = null;
		try {
			JSONObject responseObject = new JSONObject(personAddressLookupJsonResponse);
			if(responseObject != null) {
				if(responseObject.has("results")) {
					JSONArray resultsArray = responseObject.optJSONArray("results");
					if(resultsArray != null && resultsArray.length() > 0) {
						personAddressLookupData = new PersonAddressLookupData(responseObject, resultsArray);
						}
					} else if(responseObject.has("error")) {
						JSONObject errorObject = responseObject.optJSONObject("error");
						if(errorObject != null) {
							personAddressLookupData = new PersonAddressLookupData(errorObject);
							}
						}
				}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return personAddressLookupData;
	}
}
