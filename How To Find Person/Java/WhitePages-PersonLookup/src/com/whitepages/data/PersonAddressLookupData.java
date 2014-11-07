/**
 * This class contains the Person Lookup data.
 * @author Kushal Shah
 * @since  2014-06-08
 */

package com.whitepages.data;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PersonAddressLookupData {

	public PersonData[] personDataArary;
	public boolean isError = false;
	public String errorName = null;
	public String errorMessage = null;
	
	public PersonAddressLookupData(JSONObject errorObject) throws JSONException {
		this.isError = true;
		this.errorName = errorObject.optString("name");
		this.errorMessage = errorObject.optString("message");
		this.personDataArary = null;
	}
	
	public PersonAddressLookupData(JSONObject responseObject, JSONArray resultsArray) throws JSONException {		
		this.personDataArary = new PersonData[resultsArray.length()];

		JSONObject dictionaryObject = responseObject.optJSONObject("dictionary");
		if(dictionaryObject != null) {
			for(int i = 0; i < resultsArray.length(); i++) {
				String resultKey = resultsArray.optString(i);
				if(resultKey != null && !resultKey.equals("")) {
					JSONObject personObject = dictionaryObject.optJSONObject(resultKey);
					if(personObject != null) {
						PersonData personData = new PersonData(dictionaryObject, personObject);
						this.personDataArary[i] = personData;
					}	
				}
			}
		} else {
			this.personDataArary = null;
		}
	}
	
	public class LocationData {
		// Location Data
		public final String addressLine1;
		public final String addressLine2;
		public final String addressLocation;
		public final boolean isReceivingMail;
		public final String usage;
		public final String deliveryPoint;
		
		LocationData(JSONObject locationObject) throws JSONException {
			////////////////////////////////////////////////
			// Get location data related details from phone lookup data.
			//
			///////////////////////////////////////////////
			
			this.addressLine1 = locationObject.optString("standard_address_line1");
			this.addressLine2 = locationObject.optString("standard_address_line2");
			this.addressLocation = locationObject.optString("standard_address_location");
			this.isReceivingMail = locationObject.optBoolean("is_receiving_mail");
			this.usage = locationObject.optString("usage");
			this.deliveryPoint = locationObject.optString("delivery_point");
		}
	}
	
	public class PersonData {
		// person Data
		public final String name;
		public final String ageRange;
		public final String contactType;
		public final LocationData locationData;
		
		PersonData(JSONObject dictionaryObject, JSONObject personObject) throws JSONException {
			///////////////////////////////////////////////////////////////////
			// Get person data related details from person address lookup data.
			//
			///////////////////////////////////////////////////////////////////
		
			// Get age range
			JSONObject ageRangeObject = personObject.optJSONObject("age_range");
			if(ageRangeObject != null) {
				String age = ageRangeObject.optString("start");
				if(age != null && !age.equals("")) {
					this.ageRange = age + "+";
				} else {
					this.ageRange = null;
				}
			} else {
				this.ageRange = null;
			}
			
			// Get person name
			this.name = personObject.has("best_name") ? personObject.optString("best_name") : 
				(personObject.has("name") ? personObject.optString("name") : null);
			
			// Get type
			String actualLocationKey = "";
			String contactType = "";
			JSONObject personBestLocationObject = personObject.optJSONObject("best_location");
			if(personBestLocationObject != null) {
				JSONObject idObject = personBestLocationObject.optJSONObject("id");
				if(idObject != null) {
					actualLocationKey = idObject.optString("key");
					
					JSONArray locationArray = personObject.optJSONArray("locations");
					if(locationArray != null && locationArray.length() > 0) {
						for(int i = 0; i < locationArray.length(); i++) {
							JSONObject object = locationArray.optJSONObject(i);
							if(object != null) {
								JSONObject locationIdObject = object.optJSONObject("id");
								if(locationIdObject != null) {
									String locationKey = locationIdObject.optString("key");
									if(locationKey.equals(actualLocationKey)) {
										contactType = object.optString("contact_type");
										break;
									}
								}
							}
						}
					}
				}
			} else {
				JSONArray locationArray = personObject.optJSONArray("locations");
				if(locationArray != null && locationArray.length() > 0) {
					JSONObject object = locationArray.optJSONObject(0);
					if(object != null) {
						contactType = object.optString("contact_type");
						
						JSONObject locationIdObject = object.optJSONObject("id");
						if(locationIdObject != null) {
							actualLocationKey = locationIdObject.optString("key");
						}
					}
				}
			}
			
			this.contactType = contactType;
			
			JSONObject locationObject = (actualLocationKey != null && !actualLocationKey.equals("")) ? 
					dictionaryObject.optJSONObject(actualLocationKey) : null;
			
			if(locationObject != null) {
				this.locationData = new LocationData(locationObject);
			} else {
				this.locationData = null;
			}
		}
	}
}
