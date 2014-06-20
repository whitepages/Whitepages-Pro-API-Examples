package com.whitepages.utilities;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.whitepages.data.AddressLookupData;

public class AddressLookupParser {

	public AddressLookupData parseAddressLookupData(String addressLookupJsonResponse)
	{
		AddressLookupData addressLookupData = null;
		try {
				JSONObject responseObject = new JSONObject(addressLookupJsonResponse);
				if(responseObject != null)
				{
					if(responseObject.has("results"))
					{
						JSONArray resultsArray = responseObject.optJSONArray("results");
						if(resultsArray != null && resultsArray.length() > 0)
						{
							addressLookupData = new AddressLookupData(responseObject, resultsArray);
						}
					}
					else if(responseObject.has("error"))
					{
						JSONObject errorObject = responseObject.optJSONObject("error");
						if(errorObject != null)
						{
							addressLookupData = new AddressLookupData(errorObject);
						}
					}
				}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return addressLookupData;
	}
}
