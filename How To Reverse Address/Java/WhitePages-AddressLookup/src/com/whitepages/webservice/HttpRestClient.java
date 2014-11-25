/**
 * This class contains method to execute http request and return a response.
 * @author Kushal Shah
 * @since  2014-06-08
 */

package com.whitepages.webservice;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

public class HttpRestClient {
	/**
	 * This method to calls back end API and returns response.
	 * 
	 * @param request request URL.
	 * @return returns API output in string.
	 */
	public String doGetAddressLookupData(final String request) {
		String apiOutput = "";
		try {
			URL requestUrl = new URL(request);
			HttpURLConnection conn = (HttpURLConnection) requestUrl.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");

			StringBuilder response = new StringBuilder();
			String line;
			BufferedReader bufferReader = null;

			if (conn.getResponseCode() != 200) {
				System.out.println("Failed : HTTP error code : "
						+ conn.getResponseCode() + " HTTP error message : "
						+ conn.getResponseMessage());

				InputStream errorStream = conn.getErrorStream();
				if (errorStream != null) {
					bufferReader = new BufferedReader(new InputStreamReader(errorStream));
				}
			} else {
				InputStream inputStream = conn.getInputStream();
				if (inputStream != null) {
					bufferReader = new BufferedReader(new InputStreamReader(inputStream));
				}
			}

			if (bufferReader != null) {
				while ((line = bufferReader.readLine()) != null) {
					response.append(line);
				}

				apiOutput = response.toString();
				bufferReader.close();
			}

			conn.disconnect();

		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return apiOutput;
	}
}
