package com.whitepages.data;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class AddressLookupData {

	public LocationData locationData;
	public boolean isError = false;
	public String errorName = null;
	public String errorMessage = null;
	
	public AddressLookupData(JSONObject errorObject) throws JSONException
	{
		this.isError = true;
		this.errorName = errorObject.optString("name");
		this.errorMessage = errorObject.optString("message");
		this.locationData = null;
	}
	
	public AddressLookupData(JSONObject responseObject, JSONArray resultsArray) throws JSONException
	{		
		JSONObject dictionaryObject = responseObject.optJSONObject("dictionary");
		if(dictionaryObject != null)
		{
			String resultKey = resultsArray.optString(0);
			if(resultKey != null && !resultKey.equals(""))
			{
				JSONObject locationObject = dictionaryObject.optJSONObject(resultKey);
				if(locationObject != null)
				{
					this.locationData = new LocationData(dictionaryObject, locationObject, resultKey);
				}	
			}
		}
		else
		{
			this.locationData = null;
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
		public final PersonData[] personDataArray;
		
		LocationData(JSONObject dictionaryObject, JSONObject locationObject, String locationKey) throws JSONException
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
			JSONArray legalEntitiesAtArray = locationObject.getJSONArray("legal_entities_at");
			if(legalEntitiesAtArray != null && legalEntitiesAtArray.length() > 0)
			{
				this.personDataArray = new PersonData[legalEntitiesAtArray.length()];
				for(int i = 0; i < legalEntitiesAtArray.length(); i++)
				{
					JSONObject object = legalEntitiesAtArray.optJSONObject(i);
					if(object != null)
					{
						JSONObject idObject = object.optJSONObject("id");
						if(idObject != null)
						{
							String personKey = idObject.optString("key");
							if(personKey != null && !personKey.equals(""))
							{
								JSONObject personObject = dictionaryObject.optJSONObject(personKey);
								if(personObject != null)
								{
									PersonData personData = new PersonData(personObject, locationKey);
									this.personDataArray[i] = personData;
								}
							}
						}
					}
				}
			}
			else
			{
				this.personDataArray = null;
			}
		}
	}
	
	public class PersonData
	{
		// person Data
		public final String name;
		public final String contactType;
			
		PersonData(JSONObject personObject, String locationKey) throws JSONException
		{
			///////////////////////////////////////////////////////////////////
			// Get person data related details from address lookup data.
			//
			///////////////////////////////////////////////////////////////////
			
			// Get person name
			this.name = personObject.has("best_name") ? personObject.optString("best_name") : 
				(personObject.has("name") ? personObject.optString("name") : null);
			
			// Get contactType
			String contactType = "";

			JSONArray locationArray = personObject.optJSONArray("locations");
			if(locationArray != null && locationArray.length() > 0)
			{
				for(int i = 0; i < locationArray.length(); i++)
				{
					JSONObject object = locationArray.optJSONObject(i);
					if(object != null)
					{
						JSONObject locationIdObject = object.optJSONObject("id");
						if(locationIdObject != null)
						{
							String actualLocationKey = locationIdObject.optString("key");
							if(locationKey.equals(actualLocationKey))
							{
								contactType = object.optString("contact_type");
								break;
							}
						}
					}
				}
			}
			
			this.contactType = contactType;
		}
	}
}
