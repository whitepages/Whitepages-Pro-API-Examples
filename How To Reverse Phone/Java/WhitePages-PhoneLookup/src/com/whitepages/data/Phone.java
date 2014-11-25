/**
 * This class contains phone details of Phone Lookup data.
 * @author Kushal Shah
 * @since  2014-11-19
 */

package com.whitepages.data;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Phone {
	// Phone Data
	public final String phoneNumber;
	public final String countryCallingCode;
	public final String carrier;
	public final String phoneType;
	public final boolean doNotCall;
	public final String spamScore;
	public final People[] peopleDataArray;
	
	/**
	 * Constructor of Phone class to Get phone data and related details from phone lookup data.
	 * @param dictionaryObject
	 * @param phoneObject
	 * @throws JSONException
	 */
	Phone(JSONObject dictionaryObject, JSONObject phoneObject)throws JSONException {
		// Get line_type value
		this.phoneType = phoneObject.optString("line_type");

		// Get carrier value
		this.carrier = phoneObject.optString("carrier");

		// Get phone number from phoneObject.
		this.phoneNumber = (phoneObject.optString("phone_number") != null ? phoneObject.optString("phone_number") : null);

		// Get countryCallingCode from phoneObject.
		this.countryCallingCode = phoneObject.optString("country_calling_code");

		// Get do_not_call value from phoneObject.
		this.doNotCall = phoneObject.optBoolean("do_not_call", false);

		JSONObject reputationObject = phoneObject.optJSONObject("reputation");

		if (reputationObject != null) {
			// Get spam_score value
			this.spamScore = String.valueOf(reputationObject.optLong("spam_score")) + "%";
		} else {
			this.spamScore = null;
		}

		// Get belongsToArray from phoneObject.
		JSONArray belongsToArray = phoneObject.optJSONArray("belongs_to");
		if (belongsToArray != null && belongsToArray.length() > 0) {
			this.peopleDataArray = new People[belongsToArray.length()];

			for (int i = 0; i < belongsToArray.length(); i++) {
				JSONObject object = belongsToArray.optJSONObject(i);
				if (object != null) {
					// Get idObject from object.
					JSONObject idObject = object.optJSONObject("id");
					if (idObject != null) {
						// Get personKey from idObject.
						String personKey = idObject.optString("key");

						if (personKey != null && !personKey.equals("")) {
							// Calling People class constructor to get people data.
							People peopleData = new People(dictionaryObject,personKey);
							this.peopleDataArray[i] = peopleData;
						} else {
							this.peopleDataArray[i] = null;
						}
					} else {
						this.peopleDataArray[i] = null;
					}
				} else {
					this.peopleDataArray[i] = null;
				}
			}
		} else {
			this.peopleDataArray = null;
		}
	}
}
