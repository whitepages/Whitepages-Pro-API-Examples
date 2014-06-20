package com.whitepages.data;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PhoneLookupData {

	public PhoneData[] phoneDataArary;
	public boolean isError = false;
	public String errorName = null;
	public String errorMessage = null;
	
	public PhoneLookupData(JSONObject errorObject) throws JSONException
	{
		this.isError = true;
		this.errorName = errorObject.optString("name");
		this.errorMessage = errorObject.optString("message");
		this.phoneDataArary = null;
	}
	
	public PhoneLookupData(JSONObject responseObject, JSONArray resultsArray) throws JSONException
	{		
		this.phoneDataArary = new PhoneData[resultsArray.length()];

		JSONObject dictionaryObject = responseObject.optJSONObject("dictionary");
		if(dictionaryObject != null)
		{
			for(int i = 0; i < resultsArray.length(); i++)
			{
				String resultKey = resultsArray.optString(i);
				if(resultKey != null && !resultKey.equals(""))
				{
					JSONObject phoneObject = dictionaryObject.optJSONObject(resultKey);
					if(phoneObject != null)
					{
						PhoneData phoneData = new PhoneData(dictionaryObject, phoneObject);
						this.phoneDataArary[i] = phoneData;
					}	
				}
			}
		}
		else
		{
			this.phoneDataArary = null;
		}
	}
	
	public class LocationData
	{
		// Location Data
		public final String addressLine1;
		public final String addressLine2;
		public final String addressLocation;
		public final boolean isReceivingMail;
		public final String usage;
		public final String deliveryPoint;
		
		LocationData(JSONObject locationObject) throws JSONException
		{
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
	
	public class PeopleData
	{
		// People Data
		public final String type;
		public final String name;
		public final LocationData locationData;
		
		PeopleData(JSONObject dictionaryObject, String personKey) throws JSONException
		{
			////////////////////////////////////////////////
			// Get people data related details from phone lookup data.
			//
			///////////////////////////////////////////////
			
			JSONObject personObject = dictionaryObject.optJSONObject(personKey);
			
			if(personObject != null)
			{
				JSONObject idObject = personObject.optJSONObject("id");

				this.type = idObject != null ? idObject.optString("type") : null;
			
				this.name = personObject.has("best_name") ? personObject.optString("best_name") : 
					(personObject.has("name") ? personObject.optString("name") : null);
				
				JSONObject personLocationObject = personObject.optJSONObject("best_location");
				if(personLocationObject == null)
				{
					JSONArray personLocationArray = personObject.getJSONArray("locations");
					personLocationObject = personLocationArray.optJSONObject(0);
				}
				
				JSONObject personIdObject = personLocationObject != null ? personLocationObject.optJSONObject("id") : null;
				
				String locationKey = personIdObject != null ? personIdObject.optString("key") : null;
				
				JSONObject locationObject = (locationKey != null && !locationKey.equals("")) ? 
						dictionaryObject.optJSONObject(locationKey) : null;
				
				if(locationObject != null)
				{
					this.locationData = new LocationData(locationObject);
				}
				else
				{
					this.locationData = null;
				}
			}
			else
			{
				// People Data
				this.type = null;
				this.name = null;
				this.locationData = null;
			}
		}
	}
	
	public class PhoneData
	{
		// Phone Data
		public final String phoneNumber;
		public final String carrier;
		public final String phoneType;
		public final String doNotCallRegistry;
		public final String spamScore;
		public final PeopleData[] peopleDataArray;
		
		PhoneData(JSONObject dictionaryObject, JSONObject phoneObject) throws JSONException
		{
			////////////////////////////////////////////////
			// Get phone data related details from phone lookup data.
			//
			///////////////////////////////////////////////
		
			// Get line_type value
			this.phoneType = phoneObject.optString("line_type");
			
			//Get carrier value
			this.carrier = phoneObject.optString("carrier");
			
			// Create phone number in required format i.e. +1-206-973-5100
			this.phoneNumber = "+" + phoneObject.optString("country_calling_code") + "-" +
					(phoneObject.optString("phone_number") != null ? 
							phoneObject.optString("phone_number").replaceFirst("(\\d{3})(\\d{3})(\\d+)", "$1-$2-$3") : null);							
			    
			//Get do_not_call value
			this.doNotCallRegistry = phoneObject.optBoolean("do_not_call", false) ? "Registered" : "Not Registered";
			
			JSONObject reputationObject = phoneObject.optJSONObject("reputation");
			
			if(reputationObject != null)
			{
				//Get spam_score value
				this.spamScore = String.valueOf(reputationObject.optLong("spam_score")) + "%";
			}
			else
			{
				this.spamScore = null;
			}
			
			JSONArray belongsToArray = phoneObject.optJSONArray("belongs_to");
			if(belongsToArray != null && belongsToArray.length() > 0)
			{
				this.peopleDataArray = new PeopleData[belongsToArray.length()];
				
				for(int i = 0; i < belongsToArray.length(); i++)
				{
					JSONObject object = belongsToArray.optJSONObject(i);
					if(object != null)
					{
						JSONObject idObject = object.optJSONObject("id");
						if(idObject != null)
						{
							String personKey = idObject.optString("key");
							
							if(personKey != null && !personKey.equals(""))
							{
								PeopleData peopleData = new PeopleData(dictionaryObject, personKey);
								this.peopleDataArray[i] = peopleData;
							}
							else
							{
								this.peopleDataArray[i] = null;
							}
						}
						else
						{
							this.peopleDataArray[i] = null;
						}
					}
					else
					{
						this.peopleDataArray[i] = null;
					}
				}
			}
			else
			{
				this.peopleDataArray = null;
			}
		}
	}
	
}
