package com.whitepages.demo.java;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.whitepages.proapi.api.client.Client;
import com.whitepages.proapi.api.client.FindException;
import com.whitepages.proapi.api.query.PersonQuery;
import com.whitepages.proapi.api.response.Response;
import com.whitepages.proapi.api.response.ResponseMessages;
import com.whitepages.proapi.data.association.LocationAssociation;
import com.whitepages.proapi.data.association.PersonAssociation;
import com.whitepages.proapi.data.association.PhoneAssociation;
import com.whitepages.proapi.data.entity.Location;
import com.whitepages.proapi.data.entity.Person;
import com.whitepages.proapi.data.entity.Person.AgeRange;
import com.whitepages.proapi.data.entity.Person.Gender;
import com.whitepages.proapi.data.entity.Phone;
import com.whitepages.proapi.data.message.Message;
import com.whitepages.proapi.data.message.Message.Severity;
import com.whitepages.proapi.data.util.TimePeriod;

/**
 * Servlet implementation class FindPersonServlet
 */
@WebServlet(
		description = "The FindPerson demo servlet", 
		urlPatterns = { 
				"/FindPersonServlet", 
				"/FindPerson"
		})
public class FindPersonServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FindPersonServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
		super.getServletContext().getRequestDispatcher("/WEB-INF/FindPerson.jsp").forward(request, response);
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
			
			String name = request.getParameter("Name");
			String[] names = name.split(" ");
			String firstName = names[0];
			String lastName = names[1];
			
			String address = request.getParameter("Address");
			String postalCode = request.getParameter("Where");
			
			String apiKey = getApiKey();
			System.out.println("#DBG: The API key is " + apiKey);
			Client client = new Client(apiKey);
			
			PersonQuery personQuery = new PersonQuery(firstName, null, lastName, address, null, postalCode);
	
			Response<Person> apiResponse = null;
			try {
			    apiResponse = client.findPeople(personQuery);
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
		    		List<PersonModel> persons = new ArrayList<PersonModel>();
		    		
				    List<Person> results = apiResponse.getResults();
				    for (Person p : results) {
				        System.out.println("#DBG: Found person: " + p.getBestName());
				        PersonModel personModel = new PersonModel();
				        personModel.setName(p.getBestName());
				        personModel.setAgeRange(PersonModel.convertAgeRange(p.getAgeRange()));
				        Gender gender = p.getGender();
				        if (gender == null) {
				        	personModel.setGender("Unknown");
				        } else {
				        	personModel.setGender(gender.toString());
				        }
				        
				        List<PhoneAssociation> phoneAssociations = p.getPhoneAssociations();
				        if ((phoneAssociations != null) && (phoneAssociations.size() > 0)) {
				        	PhoneAssociation phoneAssociation = phoneAssociations.get(0);
				        	Phone phone = phoneAssociation.getPhone();
				        	
				        	PhoneModel phoneModel = new PhoneModel();
				        	phoneModel.setPhoneNumber(phone.getPhoneNumber());
				        	phoneModel.setDoNotCall(phone.getDoNotCall() == null ? "Unknown" : (phone.getDoNotCall().booleanValue() ? "Registered" : "Not Registered"));
				        	personModel.setPhone(phoneModel);
				        	
				        	if (phoneAssociation.getContactCreationDate().before(aYearAgo)) {
				        		personModel.setLinkedToPhone("More than 1 year ago");
				        	} else {
				        		personModel.setLinkedToPhone("Less than 1 year ago");
				        	}
				        }
				        
				        List<LocationAssociation> locationAssociations = p.getLocationAssociations();
				        if (locationAssociations != null) {
				        	
				        	for (LocationAssociation association : locationAssociations) {
				        		Location location = association.getLocation();
				        		
				        		AddressModel addressModel = new AddressModel();
				        		addressModel.setStreetAddressLine1(location.getStandardAddressLine1());
				        		addressModel.setStreetAddressLine2(location.getStandardAddressLine2());
				        		addressModel.setCity(location.getCity());
				        		addressModel.setStateCode(location.getStateCode());
				        		addressModel.setPostalCode(location.getPostalCode());
				        		addressModel.setUsage(location.getUsage() == null ? "Unknown" : location.getUsage().toString());
				        		addressModel.setIsReceivingMail(String.valueOf(location.getReceivingMail()));
				        		addressModel.setDeliveryPoint(location.getDeliveryPoint() == null ? "Unknown" : location.getDeliveryPoint().toString());
				        		TimePeriod validFor = association.getValidFor();
				        		if (validFor != null) {
					        		addressModel.setIsCurrent(validFor.getStop() == null ? true : false);
					        		addressModel.setValidFor(AddressModel.convertValidFor(validFor));
				        		}
				        		boolean isCurrent = association.getHistorical() != null && association.getHistorical().booleanValue() == false;
				        		addressModel.setIsCurrent(isCurrent);
				        		if (isCurrent) {
				        			personModel.setCurrentAddress(addressModel);
				        		}
				        		personModel.getAddresses().add(addressModel);
				        		
				        	}
				        }
				        
				        List<PersonAssociation> personAssociations = p.getPersonAssociations();
				        if (personAssociations != null) {
				        	
				        	for (PersonAssociation association : personAssociations) {
				        		Person person = association.getPerson();
				        		
				        		PersonModel associatedPerson = new PersonModel();
				        		associatedPerson.setName(person.getBestName());
				        		
				        		personModel.getAssociatedPeople().add(associatedPerson);
				        	}
				        }
				        
				        persons.add(personModel);
				    }
				    
				    request.setAttribute("persons", persons);
				    request.setAttribute("messages", apiResponse.getResponseMessages().getMessageList());
			
			    }
			} catch (FindException e) {
			    e.printStackTrace();
			    throw e;
			}
	
			
		} catch (Exception exc) {
			request.setAttribute("exception", exc);
		}
		super.getServletContext().getRequestDispatcher("/WEB-INF/FindPerson.jsp").forward(request, response);
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
