<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>WhitePages PRO Sample App - Find Person</title>
		<link href="CSS/Style.css" rel="stylesheet" />
	</head>

	<body>
		<div class="wrapper">
		    <div class="search_sec">  
		        <p>Find Person</p>  
		        <form method="post" action="person_address_lookup.jsp">  
		            <input type="text" id="person_first_name" name="first_name" placeholder="First Name" value='' class="inputbox">
		            <input type="text" id="person_last_name" name="last_name" placeholder="Last Name"  value='' class="inputbox"> 
		            <input type="text" id="person_where" name="address" placeholder="City, State, ZIP or Address"  value='' class="inputbox_address">
		            <input type="submit" name="submit" value="Find" class="find_btn" > 
		            <input type="button" name="clear" value="Clear" class="find_btn"  onclick="clearData();"> 
		        </form> 
		    </div> 

	        <%
	        	if(request.getParameter("submit") != null)
	        	{  
	        		String firstName = request.getParameter("first_name");
	        		String lastName = request.getParameter("last_name");
	        		String address = request.getParameter("address");
          			if( firstName == "" || firstName == null ) 
          			{
            %>                
						<div class="error_box">
	            			Please enter first name. 
						</div>
			<%
					}
          			else
          			{
          	%>
		    			<%@ page import="com.whitepages.webservice.PersonAddressService" %>
		    			<%@ page import="com.whitepages.data.PersonAddressLookupData" %>
			<%
						PersonAddressService personAddressService = new PersonAddressService();   
						PersonAddressLookupData personAddressLookupData = personAddressService.getPersonAddressLookupData(firstName, lastName, address);
						if(personAddressLookupData != null)
						{
							if(!personAddressLookupData.isError)
							{
			%>
								<%@ page import="com.whitepages.data.PersonAddressLookupData.PersonData"%>
								<%@ page import="com.whitepages.data.PersonAddressLookupData.LocationData"%>
								<div class="detail_wrapper"> 
          							<div class="disp_result_box">
           								<table width="100%" border="0" cellspacing="0" cellpadding="0">
           									<tr>
												<th align="left" width="30%">Who</th>
												<th align="left" width="30%">Where</th> 
											</tr> 
			<% 
											PersonData[] personDataArary = personAddressLookupData.personDataArary;
											if(personDataArary != null && personDataArary.length > 0)
											{
												for(PersonData personData: personDataArary)
												{
			%>
													<tr>
														<td > 
														    <p><%= personData.name %></p> 
			<%
														    if(personData.ageRange != null && !personData.ageRange.equals(""))
														    {
			%>
														    	<p><span>Age:</span> <%= personData.ageRange %></p>
			<%
														    }
			%>
														    
														    <p><span>Type:</span> <%= personData.contactType %></p> 
														</td> 
			<%
													LocationData locationData = personData.locationData;
													if(locationData != null)
													{
														String addressValue = "";
														if(locationData.addressLine1 != null && !locationData.addressLine1.equals(""))
														{
															addressValue += locationData.addressLine1;
														}
														
														if(locationData.addressLine2 != null && !locationData.addressLine2.equals(""))
														{
															addressValue += "<br />";
															addressValue += locationData.addressLine2;
														}
														
														if(locationData.addressLocation != null && !locationData.addressLocation.equals(""))
														{
															addressValue += "<br />";
															addressValue += locationData.addressLocation;
														}
			%>
														<td >
														    <p><%= addressValue %></p>
														    <p><span>Receiving Mail:</span> <%= locationData.isReceivingMail ? "Yes" : "No" %> </p> 
														    <p><span>Usage:</span> <%= locationData.usage %></p> 
														    <p><span>Delivery Point:</span>	<%= locationData.deliveryPoint %></p> 
														</td>
			<%
													}
													else
													{
			%>
														<td >
													    <p></p>
													    <p><span>Receiving Mail:</span> </p> 
													    <p><span>Usage:</span> </p> 
													    <p><span>Delivery Point:</span>	</p> 
														</td>
			<%
													}
			%>
													</tr>
			<%
												}
											}
			%>
										</table>
									</div>
								</div>
			<%
							
							}
							else
							{
			%>
								<div class="error_box">
								<%= personAddressLookupData.errorMessage %> 
								</div>
			<%
							}
						}
						else
						{
			%>
							<div class="error_box">
								Unknown error occurred. 
							</div>
			<%
						}
          			}
	           
	        	}
	        %>
	    </div>
	    
		<script type="text/javascript">
			function clearData() 
			{
			    document.getElementById('person_first_name').value = '';
			    document.getElementById('person_last_name').value = '';
			    document.getElementById('person_where').value = '';
			}
		</script>        
    </body>
</html>
            

