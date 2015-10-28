package com.whitepages.demo.java;

import java.util.ArrayList;
import java.util.List;

public class PhoneModel {

	private String _phoneNumber;
	private String _doNotCall;
	private String _lineType;
	private String _carrier;
	private String _reputationLevel;
	private String _prepaid;
	
	private List<PersonModel> _personAssociations = new ArrayList<PersonModel>();
	private AddressModel _address;
	
	public String getPhoneNumber() {
		return _phoneNumber;
	}
	
	public void setPhoneNumber(String phoneNumber) {
		_phoneNumber = phoneNumber;
	}
	
	public String getDoNotCall() {
		return _doNotCall;
	}
	
	public void setDoNotCall(String doNotCall) {
		_doNotCall = doNotCall;
	}
	
	public String getLineType() {
		return _lineType;
	}
	
	public void setLineType(String lineType) {
		_lineType = lineType;
	}
	
	public String getCarrier() {
		return _carrier;
	}
	
	public void setCarrier(String carrier) {
		_carrier = carrier;
	}
	
	public String getReputationLevel() {
		return _reputationLevel;
	}
	
	public void setReputationLevel(String reputationLevel) {
		_reputationLevel = reputationLevel;
	}
	
	public String getPrepaid() {
		return _prepaid;
	}
	
	public void setPrepaid(String prepaid) {
		_prepaid = prepaid;
	}
	
	public List<PersonModel> getPersonAssociations() {
		return _personAssociations;
	}
	
	public void setPersonAssociations(List<PersonModel> personAssociations) {
		_personAssociations = personAssociations;
	}
	
	public AddressModel getAddress() {
		return _address;
	}
	
	public void setAddress(AddressModel address) {
		_address = address;
	}
}
