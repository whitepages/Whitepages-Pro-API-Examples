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
import com.whitepages.proapi.api.query.PhoneQuery;
import com.whitepages.proapi.api.response.Response;
import com.whitepages.proapi.api.response.ResponseMessages;
import com.whitepages.proapi.data.association.LocationAssociation;
import com.whitepages.proapi.data.association.PersonAssociation;
import com.whitepages.proapi.data.association.PhoneAssociation;
import com.whitepages.proapi.data.entity.Location;
import com.whitepages.proapi.data.entity.Person;
import com.whitepages.proapi.data.entity.Phone;
import com.whitepages.proapi.data.entity.Phone.LineType;
import com.whitepages.proapi.data.entity.Phone.Reputation;
import com.whitepages.proapi.data.message.Message;
import com.whitepages.proapi.data.message.Message.Severity;
import com.whitepages.proapi.data.util.TimePeriod;

/**
 * Servlet implementation class ReversePhoneServlet
 */
@WebServlet(
		description = "The ReversePhone demo servlet", 
		urlPatterns = { 
				"/ReversePhoneServlet", 
				"/ReversePhone"
		})
public class ReversePhoneServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReversePhoneServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
		super.getServletContext().getRequestDispatcher("/WEB-INF/ReversePhone.jsp").forward(request, response);
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
			
			String phoneNumber = request.getParameter("phoneNumber");
			
			String apiKey = getApiKey();
			System.out.println("#DBG: The API key is " + apiKey);
			Client client = new Client(apiKey);
			
			PhoneQuery phoneQuery = new PhoneQuery(phoneNumber);
		
			Response<Phone> apiResponse = null;
			try {
			    apiResponse = client.findPhones(phoneQuery);
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
		    		List<PhoneModel> phones = new ArrayList<PhoneModel>();
		    		
				    List<Phone> results = apiResponse.getResults();
				    for (Phone phone : results) {
				        System.out.println("#DBG: Found phone: " + phone.getName());
				        PhoneModel phoneModel = new PhoneModel();
				        phoneModel.setPhoneNumber(phone.getPhoneNumber());
				        phoneModel.setCarrier(phone.getCarrier());
				        String reputationLevel = "Unknown";
				        Reputation reputation = phone.getReputation();
				        if (reputation != null) {
				        	reputationLevel = reputation.getLevel().toString();
				        }
				        phoneModel.setReputationLevel(reputationLevel);
				        phoneModel.setDoNotCall(phone.getDoNotCall() == null ? "Unknown" : (phone.getDoNotCall().booleanValue() ? "Registered" : "Unregistered"));
				        phoneModel.setPrepaid(phone.getPrepaid() == null ? "Unknown" : (phone.getPrepaid().booleanValue() ? "Yes" : "No"));
		        		phoneModel.setLineType(phone.getLineType() == null ? "Unknown" : phone.getLineType().toString());
		        		
		        		List<PersonAssociation> personAssociations = phone.getPersonAssociations();
		        		boolean isFirstPerson = true;
		        		if (personAssociations != null) {
		        			for (PersonAssociation personAssociation : personAssociations) {
		        				Person person = personAssociation.getPerson();
		        				if (person != null) {
		        					PersonModel personToAdd = new PersonModel();
		        					personToAdd.setName(person.getBestName());
		        					personToAdd.setAgeRange(PersonModel.convertAgeRange(person.getAgeRange()));
		        					personToAdd.setGender(person.getGender().toString());
		        					if (personAssociation.getContactCreationDate() == null) {
		        						personToAdd.setLinkedToAddress("Unknown");
		        					} else if (personAssociation.getContactCreationDate().before(aYearAgo)) {
						        		personToAdd.setLinkedToAddress("More than 1 year ago");
						        	} else {
						        		personToAdd.setLinkedToAddress("Less than 1 year ago");
						        	}

		        					List<PhoneAssociation> phoneAssociations = person.getPhoneAssociations();
		        					if (phoneAssociations != null && phoneAssociations.size() > 0) {
		        						PhoneAssociation firstPhoneAssociation = phoneAssociations.get(0);
		        						if (firstPhoneAssociation != null) {
		        							PhoneModel phoneToAdd = new PhoneModel();
		        							Phone firstPhone = firstPhoneAssociation.getPhone();
		        							phoneToAdd.setPhoneNumber(firstPhone.getPhoneNumber());
		        							LineType lineType = firstPhone.getLineType();
		        							if (lineType == null) {
		        								phoneToAdd.setLineType("Unknown");
		        							} else {
		        								phoneToAdd.setLineType(lineType.toString());
		        							}
		        							if (firstPhoneAssociation.getContactCreationDate() == null) {
				        						personToAdd.setLinkedToPhone("Unknown");
				        					} else if (firstPhoneAssociation.getContactCreationDate().before(aYearAgo)) {
								        		personToAdd.setLinkedToPhone("More than 1 year ago");
								        	} else {
								        		personToAdd.setLinkedToPhone("Less than 1 year ago");
								        	}
		
		        							personToAdd.setPhone(phoneToAdd);
		        						}
		        					}
		        					
		        					phoneModel.getPersonAssociations().add(personToAdd);
		        				
		        					if (isFirstPerson) {
			        					// the address should be the best location of the first person
		        						LocationAssociation bestLocationAssociation = person.getBestLocationAssociation();
		        						if (bestLocationAssociation != null) {
		        		        			Location bestLocation = bestLocationAssociation.getLocation();
		        		        			if (bestLocation != null) {
		        		        				AddressModel address = new AddressModel();
		        		        				address.setStreetAddressLine1(bestLocation.getStandardAddressLine1());
		        		        				address.setStreetAddressLine2(bestLocation.getStandardAddressLine2());
		        		        				address.setCity(bestLocation.getCity());
		        		        				address.setStateCode(bestLocation.getStateCode());
		        		        				address.setPostalCode(bestLocation.getPostalCode());
		        		        				address.setUsage(bestLocation.getUsage() == null ? "Unknown" : bestLocation.getUsage().toString());
		        		        				address.setDeliveryPoint(bestLocation.getDeliveryPoint() == null ? "Unknown" : bestLocation.getDeliveryPoint().toString());
		        		        				address.setIsReceivingMail(bestLocation.getReceivingMail() == null ? "Unknown" : (bestLocation.getReceivingMail().booleanValue() ? "Yes" : "No"));
		        		        				
		        		        				phoneModel.setAddress(address);
		        		        			}
		        		        		}
			        					
			        				}
		        					isFirstPerson = false;
		        				}
		        				
		        			}
		        		}
		        		
		        		phones.add(phoneModel);
				    }
				    
				    request.setAttribute("phones", phones);
				    request.setAttribute("messages", apiResponse.getResponseMessages().getMessageList());
			
			    }
			} catch (FindException e) {
			    e.printStackTrace();
			    throw e;
			}
	
			
		} catch (Exception exc) {
			request.setAttribute("exception", exc);
		}
		super.getServletContext().getRequestDispatcher("/WEB-INF/ReversePhone.jsp").forward(request, response);
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
