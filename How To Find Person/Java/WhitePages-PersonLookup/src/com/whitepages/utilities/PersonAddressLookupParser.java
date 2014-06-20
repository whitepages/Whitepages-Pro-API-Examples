package com.whitepages.utilities;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.whitepages.data.PersonAddressLookupData;

public class PersonAddressLookupParser {

	public PersonAddressLookupData parsePersonAdressLookupData(String personAddressLookupJsonResponse)
	{
		PersonAddressLookupData personAddressLookupData = null;
		try {
				JSONObject responseObject = new JSONObject(personAddressLookupJsonResponse);
				if(responseObject != null)
				{
					if(responseObject.has("results"))
					{
						JSONArray resultsArray = responseObject.optJSONArray("results");
						if(resultsArray != null && resultsArray.length() > 0)
						{
							personAddressLookupData = new PersonAddressLookupData(responseObject, resultsArray);
						}
					}
					else if(responseObject.has("error"))
					{
						JSONObject errorObject = responseObject.optJSONObject("error");
						if(errorObject != null)
						{
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
