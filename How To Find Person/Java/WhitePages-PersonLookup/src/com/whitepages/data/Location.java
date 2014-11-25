/**
 * This class contains the location details of Person Lookup data.
 * @author Kushal Shah
 * @since  2014-11-19
 */

package com.whitepages.data;

import org.json.JSONException;
import org.json.JSONObject;

public class Location {
	// Location Data
	public final String addressLine1;
	public final String addressLine2;
	public final String addressLocation;
	public final boolean isReceivingMail;
	public final String usage;
	public final String deliveryPoint;
	
	/**
	 * Constructor of Location class to Get location data related details from person lookup data.
	 * @param locationObject Location object.
	 * @throws JSONException
	 */
	Location(JSONObject locationObject) throws JSONException {
		// Get addressLine1, addressLine2 and addressLocation from locationObject.
		this.addressLine1 = locationObject.optString("standard_address_line1");
		this.addressLine2 = locationObject.optString("standard_address_line2");
		this.addressLocation = locationObject.optString("standard_address_location");

		// Get isReceivingMail from locationObject.
		this.isReceivingMail = locationObject.optBoolean("is_receiving_mail");

		// Get usage from locationObject.
		this.usage = locationObject.optString("usage");

		// Get deliveryPoint from locationObject.
		this.deliveryPoint = locationObject.optString("delivery_point");
	}
}
