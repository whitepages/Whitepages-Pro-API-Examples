package com.whitepages.demo.java;

import java.util.ArrayList;
import java.util.List;

import com.whitepages.proapi.data.entity.Person.AgeRange;

public class PersonModel {

	private String _name;
	private String _ageRange;
	private String _gender;
	private String _linkedToPhone;
	private String _linkedToAddress;
	
	private List<PersonModel> _associatedPeople = new ArrayList<PersonModel>();
	
	private List<AddressModel> _addresses = new ArrayList<AddressModel>();
	private AddressModel _currentAddress;
	
	private PhoneModel _phone;
	
	public String getName() {
		return _name;
	}
	
	public void setName(String name) {
		_name = name;
	}
	
	public String getAgeRange() {
		return _ageRange;
	}
	
	public void setAgeRange(String ageRange) {
		_ageRange = ageRange;
	}
	
	public String getGender() {
		return _gender;
	}
	
	public void setGender(String gender) {
		_gender = gender;
	}
	
	public String getLinkedToPhone() {
		return _linkedToPhone;
	}
	
	public void setLinkedToPhone(String linkedToPhone) {
		_linkedToPhone = linkedToPhone;
	}
	
	public String getLinkedToAddress() {
		return _linkedToAddress;
	}
	
	public void setLinkedToAddress(String linkedToAddress) {
		_linkedToAddress = linkedToAddress;
	}
	
	public List<PersonModel> getAssociatedPeople() {
		return _associatedPeople;
	}
	
	public void setAssociatedPeople(List<PersonModel> associatedPeople) {
		_associatedPeople = associatedPeople;
	}
	
	public List<AddressModel> getAddresses() {
		return _addresses;
	}
	
	public void setAddresses(List<AddressModel> addresses) {
		_addresses = addresses;
	}
	
	public AddressModel getCurrentAddress() {
		return _currentAddress;
	}
	
	public void setCurrentAddress(AddressModel currentAddress) {
		_currentAddress = currentAddress;
	}
	
	public PhoneModel getPhone() {
		return _phone;
	}
	
	public void setPhone(PhoneModel phone) {
		_phone = phone;
	}
	
	public static String convertAgeRange(AgeRange ageRange) {
		String result = "Unknown";
		if (ageRange != null) {
			result = ageRange.getStart() + "-" + ageRange.getEnd();
		}
		return result;
	}
}
