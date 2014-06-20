<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>

		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>WhitePages PRO Sample App � Reverse Phone</title>
        <style>
            *{
                margin:0px;
                padding:0px;
            }

            .wrapper{
                margin:50px auto;
                width:1000px;
            }

            .search_sec{
                float:left;
                width:1000px;
                margin:0px 0px 20px 0px;
                padding:0px;
            }

            .search_sec p{ 
                font:14px Arial, Helvetica, sans-serif;
                color:#333;
                font-weight:bold;
                margin-bottom:8px;
            }

            .inputbox{ 
                font:13px Arial, Helvetica, sans-serif;
                color:#333;
                font-weight:normal;
                padding:5px;
                width:170px;
                border:1px solid #CCC;
                border-radius:5px;
                -moz-border-radius:5px;
                -webkit-border-radius:5px;
                -o-border-radius:5px;
                -ms-border-radius:5px;
            }

            .find_btn{ 
                font:13px Arial, Helvetica, sans-serif;
                color:#fff;
                font-weight:normal;
                padding:5px 10px;
                background:#333;
                border:1px solid #CCC;
                border-radius:5px;
                -moz-border-radius:5px;
                -webkit-border-radius:5px;
                -o-border-radius:5px;
                -ms-border-radius:5px;
                cursor:pointer;
            }

            .detail_wrapper{
                float:left;
                width:1000px;
                margin:0px;
                padding:0px;
            }

            .detail_box{
                float:left;
                width:300px;
                margin:0px 30px 0px 0px;
                padding:10px;
                background:#f8f8f8;
                border:1px solid #CCC;
                border-radius:5px;
                -moz-border-radius:5px;
                -webkit-border-radius:5px;
                -o-border-radius:5px;
                -ms-border-radius:5px; 
                box-sizing:border-box;
                -moz-box-sizing:border-box;
                -webkit-box-sizing:border-box;
                -o-box-sizing:border-box;
                -ms-box-sizing:border-box;
                min-height:170px;
            }

            .detail_box h1{
                font:14px Arial, Helvetica, sans-serif;
                color:#33;
                font-weight:bold;
                padding-bottom:6px;
            }

            .detail_box p{
                font:13px Arial, Helvetica, sans-serif;
                color:#333;
                font-weight:normal;
                padding-bottom:6px;
            }

            .error_box{
                float:left;
                width:606px;
                margin:0px 0px 20px 0px;
                padding:10px;
                background:#F5E2DE;
                border:1px solid #934038;
                border-radius:5px;
                -moz-border-radius:5px;
                -webkit-border-radius:5px;
                -o-border-radius:5px;
                -ms-border-radius:5px; 
                box-sizing:border-box;
                -moz-box-sizing:border-box;
                -webkit-box-sizing:border-box;
                -o-box-sizing:border-box;
                -ms-box-sizing:border-box;
                font:13px Arial, Helvetica, sans-serif;
                color:#954338;
                font-weight:normal;
            } 

        </style>
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
          			if( phone == "" || phone == null ) 
          			{
            %>                
						<div class="error_box">
	            			please enter phone number. 
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
						PhoneLookupData phoneLookupData = phoneService.getPhoneLookUpData(phone);
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
								        <p><span>Do not Call registry:</span> <%= phoneData.doNotCallRegistry %></p>
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
