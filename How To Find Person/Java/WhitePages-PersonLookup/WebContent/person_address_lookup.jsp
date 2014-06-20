<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>WhitePages PRO Sample App � Reverse Person</title>
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
	                width:725px;
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
	
	
	            .inputbox_address{ 
	                font:13px Arial, Helvetica, sans-serif;
	                color:#333;
	                font-weight:normal;
	                padding:5px;
	                width:220px;
	                border:1px solid #CCC;
	                border-radius:5px;
	                -moz-border-radius:5px;
	                -webkit-border-radius:5px;
	                -o-border-radius:5px;
	                -ms-border-radius:5px;
	            } 
	
	
	            .detail_boxin {
	                float:left;
	                width:278px;
	                margin:0px 0px 10px 0px;
	                padding:10px;
	                background:#fff;
	                border:1px solid #ccc;
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
	                min-height:80px;	
	            }
	
	            .detail_boxin:last-child{
	                margin-bottom:0px;
	            }
	
	            .disp_result_box {
	                float:left;
	                width:960px;
	                margin:0px 0px 20px 0px;
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
	                font:13px Arial, Helvetica, sans-serif;
	                color:#333;
	                font-weight:normal;
	            }
	
	            .disp_result_box table{
	                margin:0px;
	                padding:0px;
	            }
	
	            .disp_result_box table tr, td, th{
	                margin:0px;
	                padding:0px;
	                border-collapse:collapse;
	            }
	
	            .disp_result_box table th{
	                padding:10px 0px;
	            }
	
	            .disp_result_box table td{
	                padding:10px 0px 10px 10px;
	                border-top:1px solid #ccc;
	            }
	
	            .disp_result_box table tr:hover{
	                background:#fff;
	            }
	
	            .disp_result_box table tr:first-child{
	                background: none;
	            }
	
	        </style>
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
	            			please enter first name. 
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
						PersonAddressLookupData personAddressLookupData = personAddressService.getPersonAddressLookUpData(firstName, lastName, address);
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
            

