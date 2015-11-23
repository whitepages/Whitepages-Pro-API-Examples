package com.whitepages.demo.java;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Map.Entry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.whitepages.proapi.api.client.Client;
import com.whitepages.proapi.api.client.FindException;
import com.whitepages.proapi.api.query.LocationQuery;
import com.whitepages.proapi.api.query.PersonQuery;
import com.whitepages.proapi.api.response.Response;
import com.whitepages.proapi.api.response.ResponseMessages;
import com.whitepages.proapi.data.association.LocationAssociation;
import com.whitepages.proapi.data.association.PersonAssociation;
import com.whitepages.proapi.data.association.PhoneAssociation;
import com.whitepages.proapi.data.entity.Location;
import com.whitepages.proapi.data.entity.Person;
import com.whitepages.proapi.data.entity.Person.Gender;
import com.whitepages.proapi.data.entity.Phone;
import com.whitepages.proapi.data.entity.Phone.LineType;
import com.whitepages.proapi.data.message.Message;
import com.whitepages.proapi.data.message.Message.Severity;
import com.whitepages.proapi.data.util.TimePeriod;

/**
 * Servlet implementation class ReverseAddressServlet
 */
@WebServlet(
		description = "The ReverseAddress demo servlet", 
		urlPatterns = { 
				"/ReverseAddressServlet", 
				"/ReverseAddress"
		})
public class ReverseAddressServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReverseAddressServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
		super.getServletContext().getRequestDispatcher("/WEB-INF/ReverseAddress.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			Calendar now = Calendar.getInstance();
			now.add(Calendar.YEAR, -1);
			Date aYearAgo = now.getTime();
			
			String method = request.getMethod();
			System.out.println("#DBG: The request method is " + method);
			request.setAttribute("httpMethod", method);
			
			// DEBUG: post parameters
			System.out.println("#DBG: Starting debug output of form parameters");
			for (Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
				System.out.println(String.format("[%s]='%s'", entry.getKey(), entry.getValue()[0]));
			}
			System.out.println("#DBG: end debug output of form parameters");
			// END DEBUG
			
			String streetAddress1 = request.getParameter("Address");
			String where = request.getParameter("Where");
			String[] whereElements = where.split(" ");
			String city = "";
			String stateCode = "";
			String postalCode = "";
			if (whereElements.length == 3) {
				city = whereElements[0];
				stateCode = whereElements[1];
				postalCode = whereElements[2];
			} else if (whereElements.length == 1) {
				if (whereElements[0].matches("\\d{5}")) {
					postalCode = whereElements[0];
				} else {
					// assume city
					city = whereElements[1];
				}
			} else if (whereElements.length == 2) {
				// assume city and state?
				city = whereElements[0];
				stateCode = whereElements[1];
			}
			
			String apiKey = getApiKey();
			System.out.println("#DBG: The API key is " + apiKey);
			Client client = new Client(apiKey);
			
			LocationQuery locationQuery = new LocationQuery(streetAddress1, null, city, stateCode, postalCode);
			
	
			Response<Location> apiResponse = null;
			try {
			    apiResponse = client.findLocations(locationQuery);
			    if (apiResponse == null) {
			    	System.out.println("#DBG: The API response is NULL!");
			    } else {
			    	boolean success = apiResponse.isSuccess();
			    	System.out.println("#DBG: Was the API call successful? " + String.valueOf(success));
			    	
			    	ResponseMessages messages = apiResponse.getResponseMessages();
			    	Iterator<Message> iter = messages.iterator();
			    	while (iter.hasNext()) {
			    		Message m = iter.next();
			    		Message.Code code = m.getCode();
			    		String message = m.getMessage();
			    		Severity severity = m.getSeverity();
			    		
			    		String mstr = String.format("#DBG: %s: %s (%s)", (code == null ? "null" : code.toString()), message, severity.toString());
			    		System.out.println(mstr);
			    		
			    	}
		    		request.setAttribute("isSuccess", true);
		    		List<AddressModel> addresses = new ArrayList<AddressModel>();
		    		
				    List<Location> results = apiResponse.getResults();
				    for (Location location : results) {
				        System.out.println("#DBG: Found location: " + location.getName());
				        AddressModel addressModel = new AddressModel();
		        		addressModel.setStreetAddressLine1(location.getStandardAddressLine1());
		        		addressModel.setStreetAddressLine2(location.getStandardAddressLine2());
		        		addressModel.setCity(location.getCity());
		        		addressModel.setStateCode(location.getStateCode());
		        		addressModel.setPostalCode(location.getPostalCode());
		        		addressModel.setUsage(location.getUsage() == null ? "Unknown" : location.getUsage().toString());
		        		addressModel.setIsReceivingMail(String.valueOf(location.getReceivingMail()));
		        		addressModel.setDeliveryPoint(location.getDeliveryPoint() == null ? "Unknown" : location.getDeliveryPoint().toString());
		        		TimePeriod validFor = location.getValidFor();
		        		if (validFor != null) {
			        		addressModel.setIsCurrent(validFor.getStop() == null ? true : false);
			        		addressModel.setValidFor(AddressModel.convertValidFor(validFor));
		        		}
		        		
		        		List<PersonAssociation> personAssociations = location.getPersonAssociations();
		        		if (personAssociations != null) {
		        			for (PersonAssociation personAssociation : personAssociations) {
		        				Person person = personAssociation.getPerson();
		        				if (person != null) {
		        					PersonModel personToAdd = new PersonModel();
		        					
        							if (personAssociation.getContactCreationDate() == null) {
		        						personToAdd.setLinkedToAddress("Unknown");
		        					} else if (personAssociation.getContactCreationDate().before(aYearAgo)) {
						        		personToAdd.setLinkedToAddress("More than 1 year ago");
						        	} else {
						        		personToAdd.setLinkedToAddress("Less than 1 year ago");
						        	}

		        					personToAdd.setName(person.getBestName());
		        					personToAdd.setAgeRange(PersonModel.convertAgeRange(person.getAgeRange()));
		        					Gender gender = person.getGender();
		        					if (gender == null) {
		        						personToAdd.setGender("Unknown");
		        					} else {
		        						personToAdd.setGender(gender.toString());
		        					}
		        					if (personAssociation.getContactCreationDate() == null) {
		        						personToAdd.setLinkedToAddress("Unknown");
		        					} else if (personAssociation.getContactCreationDate().before(aYearAgo)) {
						        		personToAdd.setLinkedToAddress("More than 1 year ago");
						        	} else {
						        		personToAdd.setLinkedToAddress("Less than 1 year ago");
						        	}

		        					String linkedToPhone = "Unknown";
		        					List<PhoneAssociation> phoneAssociations = person.getPhoneAssociations();
		        					if (phoneAssociations != null && phoneAssociations.size() > 0) {
		        						PhoneAssociation firstPhoneAssociation = phoneAssociations.get(0);
		        						if (firstPhoneAssociation != null) {
		        							PhoneModel phoneToAdd = new PhoneModel();
		        							Phone phone = firstPhoneAssociation.getPhone();
		        							phoneToAdd.setPhoneNumber(phone.getPhoneNumber());
		        							LineType lineType = phone.getLineType();
		        							if (lineType == null) {
		        								phoneToAdd.setLineType("Unknown");
		        							} else {
		        								phoneToAdd.setLineType(lineType.toString());
		        							}
		        							if (firstPhoneAssociation.getContactCreationDate() == null) {
				        						linkedToPhone = "Unknown";
				        					} else if (firstPhoneAssociation.getContactCreationDate().before(aYearAgo)) {
								        		linkedToPhone = "More than 1 year ago";
								        	} else {
								        		linkedToPhone = "Less than 1 year ago";
								        	}
		
		        							personToAdd.setPhone(phoneToAdd);
		        						}
		        						personToAdd.setLinkedToPhone(linkedToPhone);
		        					}
		
		        					List<LocationAssociation> locationAssociations = person.getLocationAssociations();
		        					if (locationAssociations != null && locationAssociations.size() > 0) {
		        						for (LocationAssociation p_locationAssociation : locationAssociations) {
		        							AddressModel addressToAdd = new AddressModel();
		        							Location p_location = p_locationAssociation.getLocation();
		        							addressToAdd.setStreetAddressLine1(p_location.getStandardAddressLine1());
		        			        		addressToAdd.setStreetAddressLine2(p_location.getStandardAddressLine2());
		        			        		addressToAdd.setCity(p_location.getCity());
		        			        		addressToAdd.setStateCode(p_location.getStateCode());
		        			        		addressToAdd.setPostalCode(p_location.getPostalCode());
		        			        		addressToAdd.setUsage(p_location.getUsage() == null ? "Unknown" : p_location.getUsage().toString());
		        			        		addressToAdd.setIsReceivingMail(String.valueOf(p_location.getReceivingMail()));
		        			        		addressToAdd.setDeliveryPoint(p_location.getDeliveryPoint() == null ? "Unknown" : p_location.getDeliveryPoint().toString());
		        			        		TimePeriod p_validFor = p_location.getValidFor();
		        			        		if (p_validFor != null) {
		        				        		addressToAdd.setIsCurrent(p_validFor.getStop() == null ? true : false);
		        				        		addressToAdd.setValidFor(AddressModel.convertValidFor(p_validFor));
		        			        		}
		
		        							personToAdd.getAddresses().add(addressToAdd);
		        						}
		        					}
		
		        					addressModel.getPersonAssociations().add(personToAdd);
		        				}
		        			}
		        		}
		        		
		        		addresses.add(addressModel);
				    }
				    
				    request.setAttribute("addresses", addresses);
				    request.setAttribute("messages", apiResponse.getResponseMessages().getMessageList());
			
			    }
			} catch (FindException e) {
			    e.printStackTrace();
			    throw e;
			}
	
			
		} catch (Exception exc) {
			request.setAttribute("exception", exc);
		}
		super.getServletContext().getRequestDispatcher("/WEB-INF/ReverseAddress.jsp").forward(request, response);
	}
	
	private String getApiKey() throws IOException {
		String key = getApiKeyFromEnvironment();
		if ((key == null) || (key.isEmpty())) {
			key = getApiKeyFromProperties();
		}
		return key;
	}
	
	private String getApiKeyFromEnvironment() {
		return System.getenv("apiKey");
	}
	
	private String getApiKeyFromProperties() throws IOException {
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties properties = new Properties();
		properties.load(loader.getResourceAsStream("demo.properties"));
		String apiKey = properties.getProperty("apiKey");
		return apiKey;
	}

}
