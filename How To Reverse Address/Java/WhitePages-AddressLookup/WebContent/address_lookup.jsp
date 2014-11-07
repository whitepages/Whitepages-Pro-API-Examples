<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>WhitePages PRO Sample App – Reverse Address</title>
		<link href="CSS/Style.css" rel="stylesheet" />
 	</head>
 	<body>
 		<div class="wrapper">
			<div class="search_sec">
				<p>Find by address</p>
				<form method="post" action="address_lookup.jsp">
					<input type="text" name="street_line_1" value='' id="street_line_1"
						class="inputbox_address" placeholder="Street Address or name">
					<input type="text" name="city" value='' id="city"
						class="inputbox_address" placeholder="City and State or Zip">
					<input type="Submit" name="submit" value="Find" class="find_btn">
					<input type="button" name="clear" value="Clear" class="find_btn"
						onclick="clearData();">
				</form>
			</div>
			<%
				if (request.getParameter("submit") != null)
				{
					String streetName = request.getParameter("street_line_1");
					String cityName = request.getParameter("city");
	
					if (streetName == "" || streetName == null) 
					{
			%>
			        	<div class="error_box">please enter your address details.</div>
			<%
			     	}
					else
					{
			%>
		    			<%@ page import="com.whitepages.webservice.AddressService" %>
		    			<%@ page import="com.whitepages.data.AddressLookupData" %>
			<%
						AddressService addressService = new AddressService();   
						AddressLookupData addressLookupData = addressService.getAddressLookupData(streetName, cityName);
						if(addressLookupData != null)
						{
							if(!addressLookupData.isError)
							{
			%>					
								<%@ page import="com.whitepages.data.AddressLookupData.LocationData"%>
								<%@ page import="com.whitepages.data.AddressLookupData.PersonData"%>
					
								<div class="detail_wrapper">
					            	<div class="detail_box">
					                	<h1>Location</h1>
			<%
								PersonData[] personDataArray = null;
								LocationData locationData = addressLookupData.locationData;
								if(locationData != null)
								{
									personDataArray = locationData.personDataArray;
									
									String address = "";
									if(locationData.addressLine1 != null && !locationData.addressLine1.equals(""))
									{
										address += locationData.addressLine1;
									}
									
									if(locationData.addressLine2 != null && !locationData.addressLine2.equals(""))
									{
										address += "<br />";
										address += locationData.addressLine2;
									}
									
									if(locationData.addressLocation != null && !locationData.addressLocation.equals(""))
									{
										address += "<br />";
										address += locationData.addressLocation;
									}
			%>
										<div class="detail_boxin">
											<p><%= address %></p>
										</div>
										<div class="detail_boxin">
											<p><span>Receiving Mail:</span> <%= locationData.isReceivingMail ? "Yes" : "No" %></p>
											<p><span>Usage:</span> <%= locationData.usage %></p>
											<p><span>Delivery Point:</span>	<%= locationData.deliveryPoint %></p>
										</div>
			<% 
								}
								
								int peopleCount = (personDataArray != null && personDataArray.length > 0) ? personDataArray.length : 0; 
			%>
									</div>
									<div class="detail_box">
										<h1>People <span>(<%= peopleCount %>)</span></h1>
			<%
										if(personDataArray != null && personDataArray.length > 0)
										{
											for(PersonData personData : personDataArray)
											{
			%>
												<div class="detail_boxin">
													<p><%= personData.name %></p>
													<p><span>Type:</span> <%= personData.contactType %></p>
												</div>
			<%
											}
										}
			%>
									</div>
								</div>	
			<%
							}
							else
							{
			%>
								<div class="error_box">
								<%= addressLookupData.errorMessage %> 
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
				document.getElementById('street_line_1').value = '';
				document.getElementById('city').value = '';
			}
		</script>
	</body>
</html>