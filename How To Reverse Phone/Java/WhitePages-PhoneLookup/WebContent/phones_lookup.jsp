<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>WhitePages PRO Sample App - Reverse Phone</title>
        <link href="CSS/Style.css" rel="stylesheet" />
    </head>
    <body>     
        <div class="wrapper">
            <div class="search_sec"> 
                <p>Find by Phone</p>
                <form method="post" action="phones_lookup.jsp">
                    <input type="text" name="phone" placeholder="Phone number" value='' id="phone" class="inputbox" > 
                    <input type="Submit" name="submit" value="Find" class="find_btn"> 
                    <input type="button" name="clear" value="Clear" class="find_btn" onclick="clearData();"> 
                </form>
            </div>
            
            <%
              	if(request.getParameter("submit") != null)
                {
          		  	String phone = request.getParameter("phone");
          			if( phone == null || phone == "" ) 
          			{
            %>                
						<div class="error_box">
	            			Please enter phone number. 
						</div>
			<%
					} 
					else
					{
			%>
		    			<%@ page import="com.whitepages.webservice.PhoneService" %>
		    			<%@ page import="com.whitepages.data.PhoneLookupData" %>
			<%
						PhoneService phoneService = new PhoneService();   
						PhoneLookupData phoneLookupData = phoneService.getPhoneLookupData(phone);
						if(phoneLookupData != null)
						{
							if(!phoneLookupData.isError)
							{
			%>					
								<%@ page import="com.whitepages.data.PhoneLookupData.PhoneData"%>
								<%@ page import="com.whitepages.data.PhoneLookupData.PeopleData"%>
								<%@ page import="com.whitepages.data.PhoneLookupData.LocationData"%>
			
								<div class="detail_wrapper">
							    	<div class="detail_box">
							        	<h1>Phone</h1>
			<%				        	
								PhoneData[] phoneDataArray = phoneLookupData.phoneDataArary;
								if(phoneDataArray != null && phoneDataArray.length > 0)
								{
									for(PhoneData phoneData: phoneDataArray)
									{
			%>
								        <p><%= phoneData.phoneNumber %> </p>
								        <p><span>Carrier:</span> <%= phoneData.carrier %> </p>
								        <p><span>Phone Type:</span> <%= phoneData.phoneType %> </p>
								        <p><span>Do not Call registry:</span> <%= phoneData.doNotCall %></p>
								        <p><span>Spam Score:</span> <%= phoneData.spamScore %></p>
								        <p><br /></p>
			<%
									}
								}
			%>
									</div>
									<div class="detail_box">
										<h1>People</h1>
			<%		
								if(phoneDataArray != null && phoneDataArray.length > 0)
								{
									for(PhoneData phoneData: phoneDataArray)
									{
										PeopleData[] peopleDataArray = phoneData.peopleDataArray;
										if(peopleDataArray != null && peopleDataArray.length > 0)
										{
											for(PeopleData peopleData: peopleDataArray)
											{
			%>
												<p><%= peopleData.name %></p>			        
										        <p><span>Type:</span> <%= peopleData.type %></p> 
										        <p><br /></p> 
			<%
											}
										}
										
									}
								}
			%>
									</div>
									<div class="detail_box">
					        			<h1>Location </h1>
			<%		
								if(phoneDataArray != null && phoneDataArray.length > 0)
								{
									for(PhoneData phoneData: phoneDataArray)
									{
										PeopleData[] peopleDataArray = phoneData.peopleDataArray;
										if(peopleDataArray != null && peopleDataArray.length > 0)
										{
											for(PeopleData peopleData: peopleDataArray)
											{
												LocationData locationData = peopleData.locationData;
												if(locationData != null)
												{
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
													<p><%= address %></p>
											        <p><span>Receiving mail:</span> <%= locationData.isReceivingMail ? "Yes" : "No" %></p>
											        <p><span>Usage:</span> <%= locationData.usage %></p>
											        <p><span>Delivery Point:</span> <%= locationData.deliveryPoint %></p>
											        <p><br /></p>
			<% 
												}
											}
										}
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
								<%= phoneLookupData.errorMessage %> 
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
				document.getElementById('phone').value = '';
			}
		</script>
    </body>
</html>
