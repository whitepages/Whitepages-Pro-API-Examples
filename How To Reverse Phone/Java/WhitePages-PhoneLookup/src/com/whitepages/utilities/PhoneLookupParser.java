package com.whitepages.utilities;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.whitepages.data.PhoneLookupData;

public class PhoneLookupParser {

	public PhoneLookupData parsePhoneLookupData(String phoneLookupJsonResponse)
	{
		PhoneLookupData phoneLookupData = null;
		try {
				JSONObject responseObject = new JSONObject(phoneLookupJsonResponse);
				if(responseObject != null)
				{
					if(responseObject.has("results"))
					{
						JSONArray resultsArray = responseObject.optJSONArray("results");
						if(resultsArray != null && resultsArray.length() > 0)
						{
							phoneLookupData = new PhoneLookupData(responseObject, resultsArray);
						}
					}
					else if(responseObject.has("error"))
					{
						JSONObject errorObject = responseObject.optJSONObject("error");
						if(errorObject != null)
						{
							phoneLookupData = new PhoneLookupData(errorObject);
						}
					}
				}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return phoneLookupData;
	}
}
