/**
 * This class contains method to create Phone Lookup data, request and parse response data.
 * @author Kushal Shah
 * @since  2014-06-08
 */

package com.whitepages.webservice;

import com.whitepages.data.Result;
import com.whitepages.utilities.PhoneLookupParser;
import com.whitepages.utilities.ServerApis;
import com.whitepages.utilities.ServerUrls;
import com.whitepages.utilities.Constants;

public class PhoneService {

	/**
	 * This method to calls method doGetPhoneLookupData to get response of API
	 * and calls parseDataResonse to parse the result and returns
	 * PhoneLookupData object.
	 * 
	 * @param phoneNumber phone number.
	 * @return PhoneLookupData.
	 */
	public Result getPhoneLookupData(String phoneNumber) {
		Result phoneLookupData = null;

		if (phoneNumber != null && !phoneNumber.equals("")) {
			phoneNumber = phoneNumber.trim();
			String request = getPhoneLookupRequest(phoneNumber);
			HttpRestClient httpRestClient = new HttpRestClient();
			String response = httpRestClient.doGetPhoneLookupData(request);

			// Parse phone lookup data json response
			phoneLookupData = parseDataResonse(response);
		}

		return phoneLookupData;
	}

	/**
	 * This method creates a request to get phone lookup data.
	 * 
	 * @param phoneNumber phone number to get data.
	 * @return request to get phone data.
	 */
	private String getPhoneLookupRequest(String phoneNumber) {
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

	/**
	 * This method parse JSON response for phone lookup data. 
	 * @param jsonResponse
	 * @return resultData
	 */
	private Result parseDataResonse(String jsonResponse) {
		Result resultData = null;
		if (jsonResponse != null && !jsonResponse.equals("")) {
			PhoneLookupParser phoneLookupParser = new PhoneLookupParser();
			resultData = phoneLookupParser.parsePhoneLookupData(jsonResponse);
		}

		return resultData;
	}
}
