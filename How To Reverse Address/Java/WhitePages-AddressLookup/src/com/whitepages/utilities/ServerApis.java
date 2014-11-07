/**
 * This class contains white pages Api name.
 * @author Kushal Shah
 * @since  2014-06-08
 */

package com.whitepages.utilities;

public class ServerApis {
	// White pages API version
	public static String API_VERSION = "2.0";
	
	// White pages address API name.
	public static String ADDRESS_API = "/location.json";
	
	// White pages address API request parameters.
	public static String ADDRESS_API_REQUEST_PARAM = "street_line_1=:street_line_1&city=:city&api_key=:api_key";
}
