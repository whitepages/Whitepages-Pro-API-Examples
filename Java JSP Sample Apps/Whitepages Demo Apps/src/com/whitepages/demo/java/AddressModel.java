package com.whitepages.demo.java;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.whitepages.proapi.data.util.TimePeriod;

public class AddressModel {

	private String _streetAddressLine1;
	private String _streetAddressLine2;
	private String _city;
	private String _stateCode;
	private String _postalCode;
	private String _isReceivingMail;
	private String _usage;
	private String _deliveryPoint;
	private String _validFor;
	private boolean _isCurrent;
	private List<PersonModel> _personAssociations = new ArrayList<PersonModel>();
	
	public String getStreetAddressLine1() {
		return _streetAddressLine1;
	}
	
	public void setStreetAddressLine1(String streetAddressLine1) {
		_streetAddressLine1 = streetAddressLine1;
	}
	
	public String getStreetAddressLine2() {
		return _streetAddressLine2;
	}
	
	public void setStreetAddressLine2(String streetAddressLine2) {
		_streetAddressLine2 = streetAddressLine2;
	}
	
	public String getCity() {
		return _city;
	}
	
	public void setCity(String city) {
		_city = city;
	}
	
	public String getStateCode() {
		return _stateCode;
	}
	
	public void setStateCode(String stateCode) {
		_stateCode = stateCode;
	}
	
	public String getPostalCode() {
		return _postalCode;
	}
	
	public void setPostalCode(String postalCode) {
		_postalCode = postalCode;
	}
	
	public String getIsReceivingMail() {
		return _isReceivingMail;
	}
	
	public void setIsReceivingMail(String isReceivingMail) {
		_isReceivingMail = isReceivingMail;
	}
	
	public String getUsage() {
		return _usage;
	}
	
	public void setUsage(String usage) {
		_usage = usage;
	}
	
	public String getDeliveryPoint() {
		return _deliveryPoint;
	}
	
	public void setDeliveryPoint(String deliveryPoint) {
		_deliveryPoint = deliveryPoint;
	}
	
	public String getValidFor() {
		return _validFor;
	}
	
	public void setValidFor(String validFor) {
		_validFor = validFor;
	}
	
	public boolean getIsCurrent() {
		return _isCurrent;
	}
	
	public void setIsCurrent(boolean isCurrent) {
		_isCurrent = isCurrent;
	}
	
	public List<PersonModel> getPersonAssociations() {
		return _personAssociations;
	}
	
	public void setPersonAssociations(List<PersonModel> personAssociations) {
		_personAssociations = personAssociations;
	}
	
	public String getHtml() {
		String result = _streetAddressLine1;
		if (_streetAddressLine2 != null && !_streetAddressLine2.isEmpty()) {
			result += "<br/>" + _streetAddressLine2;
		}
		result += "<br/>";
		result += _city;
		result += "&nbsp;";
		result += _stateCode;
		result += "&nbsp;";
		result += _postalCode;
		return result;
	}
	
	public static String getLengthOfTime(TimePeriod validFor) {
		String ret = "Unknown";
		
		if (validFor != null) {
			Calendar nowCalendar = Calendar.getInstance();
			Date now = nowCalendar.getTime();
			
			if (validFor.getStop() == null) {
				// time between start and now
				
				long diff = now.getTime() - validFor.getStart().getTime();
		        
		        ret = getDurationAsString(diff);
				
			} else {
				long diff = validFor.getStop().getTime() - validFor.getStart().getTime();
				ret = getDurationAsString(diff);
			}
		}
		return ret;
	}
	
	private static String getDurationAsString(long ms) {
		long diffDays = ms / (60 * 60 * 1000 * 24);
		if (diffDays > 730) {
			return " (about " + String.valueOf(diffDays / 365) + " years)";
		} else if (diffDays > 30) {
			return " (" + String.valueOf(diffDays / 30) + " months)";
		} else if (diffDays > 1) {
			return " (" + String.valueOf(diffDays) + " days)";
		} else {
			return "";
		}
	}
	
	public static String convertValidFor(TimePeriod validFor) {
		String ret = "Unknown";
		if (validFor != null) {
			SimpleDateFormat sdf = new SimpleDateFormat("MMMM, YYYY");
			Date start = validFor.getStart();
			if (start == null) {
				ret = "?";
			} else {
				ret = sdf.format(start);
				ret += " - ";
			}
			
			Date end = validFor.getStop();
			if (end == null || end.getTime() < 0) {
				ret += "Current";
			} else {
				ret += sdf.format(end);
			}
			
			ret += getLengthOfTime(validFor);
			
		}
		
		return ret;
	}
}
