<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>WhitePages PRO Sample App – Reverse Address</title>
		<style>
* {
	margin: 0px;
	padding: 0px;
}

.wrapper {
	margin: 50px auto;
	width: 1000px;
}

.search_sec {
	float: left;
	width: 1000px;
	margin: 0px 0px 20px 0px;
	padding: 0px;
}

.search_sec p {
	font: 14px Arial, Helvetica, sans-serif;
	color: #333;
	font-weight: bold;
	margin-bottom: 8px;
}

.inputbox {
	font: 13px Arial, Helvetica, sans-serif;
	color: #333;
	font-weight: normal;
	padding: 5px;
	width: 170px;
	border: 1px solid #CCC;
	border-radius: 5px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	-o-border-radius: 5px;
	-ms-border-radius: 5px;
}

.find_btn {
	font: 13px Arial, Helvetica, sans-serif;
	color: #fff;
	font-weight: normal;
	padding: 5px 10px;
	background: #333;
	border: 1px solid #CCC;
	border-radius: 5px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	-o-border-radius: 5px;
	-ms-border-radius: 5px;
	cursor: pointer;
}

.detail_wrapper {
	float: left;
	width: 1000px;
	margin: 0px;
	padding: 0px;
}

.detail_box {
	float: left;
	width: 300px;
	margin: 0px 30px 0px 0px;
	padding: 10px;
	background: #f8f8f8;
	border: 1px solid #CCC;
	border-radius: 5px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	-o-border-radius: 5px;
	-ms-border-radius: 5px;
	box-sizing: border-box;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	-o-box-sizing: border-box;
	-ms-box-sizing: border-box;
	min-height: 170px;
}

.detail_box h1 {
	font: 14px Arial, Helvetica, sans-serif;
	color: #33;
	font-weight: bold;
	padding-bottom: 6px;
}

.detail_box p {
	font: 13px Arial, Helvetica, sans-serif;
	color: #333;
	font-weight: normal;
	padding-bottom: 6px;
}

.error_box {
	float: left;
	width: 588px;
	margin: 0px 0px 20px 0px;
	padding: 10px;
	background: #F5E2DE;
	border: 1px solid #934038;
	border-radius: 5px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	-o-border-radius: 5px;
	-ms-border-radius: 5px;
	box-sizing: border-box;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	-o-box-sizing: border-box;
	-ms-box-sizing: border-box;
	font: 13px Arial, Helvetica, sans-serif;
	color: #954338;
	font-weight: normal;
}

.inputbox_address {
	font: 13px Arial, Helvetica, sans-serif;
	color: #333;
	font-weight: normal;
	padding: 5px;
	width: 220px;
	border: 1px solid #CCC;
	border-radius: 5px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	-o-border-radius: 5px;
	-ms-border-radius: 5px;
}

.detail_boxin {
	float: left;
	width: 278px;
	margin: 0px 0px 10px 0px;
	padding: 10px;
	background: #fff;
	border: 1px solid #ccc;
	border-radius: 5px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	-o-border-radius: 5px;
	-ms-border-radius: 5px;
	box-sizing: border-box;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	-o-box-sizing: border-box;
	-ms-box-sizing: border-box;
	min-height: 80px;
}

.detail_boxin:last-child {
	margin-bottom: 0px;
}
</style>
 	</head>
 	<body>
 		<div class="wrapper">
			<div class="search_sec">
				<p>Find by Address</p>
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
						AddressLookupData addressLookupData = addressService.getAddressLookUpData(streetName, cityName);
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