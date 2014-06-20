package com.whitepages.webservice;

import com.whitepages.data.PhoneLookupData;
import com.whitepages.utilities.PhoneLookupParser;
import com.whitepages.utilities.ServerApis;
import com.whitepages.utilities.ServerUrls;
import com.whitepages.utilities.Constants;

public class PhoneService {

	public PhoneLookupData getPhoneLookUpData(String phoneNumber)
	{
		PhoneLookupData phoneLookupData = null;
		
		if(phoneNumber != null && phoneNumber != "")
		{
			phoneNumber = phoneNumber.trim();
			String request = getPhoneLookUpRequest(phoneNumber);
			HttpRestClient httpRestClient = new HttpRestClient();
			String response = httpRestClient.doGetPhonelookupData(request);
			
			// Parse phone lookup data json response
			phoneLookupData = parseDataResonse(response);
		}
		
		return phoneLookupData;
	}
	
	/**
	 * This method create a request to get phone lookup data.
	 * @param phoneNumber: phone number to get data.
	 * @return: request to get phone data.
	 */
	private String getPhoneLookUpRequest(String phoneNumber)
	{
		String request = null;
		String serverUrl = ServerUrls.SERVER_URL;
		String apiVersion = ServerApis.API_VERSION;
		String phoneApi = ServerApis.PHONE_API;
		String apiKey = Constants.API_KEY;
		String apiRequestParam = ServerApis.PHONE_API_REQUEST_PARAM;
		apiRequestParam = apiRequestParam.replace(":phoneNumber", phoneNumber);
		apiRequestParam = apiRequestParam.replace(":api_key", apiKey);
		
		request = serverUrl + apiVersion + phoneApi + "?" + apiRequestParam;
		return request;
	}
	
	private PhoneLookupData parseDataResonse(String jsonResponse)
	{
		PhoneLookupData phoneLookupData = null;
		if(jsonResponse != null && !jsonResponse.equals(""))
		{
			PhoneLookupParser phoneLookupParser = new PhoneLookupParser();
			phoneLookupData = phoneLookupParser.parsePhoneLookupData(jsonResponse);
		}
		
		return phoneLookupData;
	}
}
