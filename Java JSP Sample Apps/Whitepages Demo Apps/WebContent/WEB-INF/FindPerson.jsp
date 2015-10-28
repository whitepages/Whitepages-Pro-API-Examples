<%@ page language="java" 
	contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    trimDirectiveWhitespaces="true"
    import="com.whitepages.proapi.api.response.Response,com.whitepages.proapi.data.entity.Person,com.whitepages.proapi.api.response.ResponseMessages"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="root" value="${pageContext.request.contextPath}" />
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Find Person - Whitepages Pro API Demo</title>
<link rel="stylesheet" href="${root}/css/Site.css" type="text/css" />
<style type="text/css">
    .label-floatlabel {
        position: absolute; top: 0px; left: 8px; display: block; opacity: 1; font-size: 11px; font-weight: bold; color: rgb(131, 135, 128); transition: all 0.1s ease-in-out;
    }
    .float-label {
        padding-top: 12px; transition: all 0.1s ease-in-out;
    }
</style>

</head>
<body>
	<h1>Find Person</h1>
	<c:choose>
		<c:when test="${exception ne null}">
			<div>
				EXCEPTION: ${exception.toString()}
			</div>
		</c:when>
	</c:choose>
	
	<form action="${root}/FindPersonServlet" method="POST">
		<div class="row">
	        <div class="col-md-12 tab-content">
	            <div class="inner tab-pane active" id="lookup-people">
	                <div class="form-group">
	                    <div class="floatlabel-wrapper" style="position:relative">
	                        <label for="person_name" class="label-floatlabel">Name</label>
	                        <input placeholder="Name" name="Name" value="" class="right-connect form-control float-label active-floatlabel" type="text" id="person_name">
	                    </div>
	                </div>
	                <div class="form-group">
	                    <div class="floatlabel-wrapper" style="position:relative">
	                        <label for="person_address" class="label-floatlabel">Street Address (optional)</label>
	                        <input placeholder="Street Address (optional)" name="Address" value="" class="both-connect form-control float-label" type="text" id="person_address">
	                    </div>
	                </div>
	                <div class="form-group">
	                    <div class="input-group">
							<div class="floatlabel-wrapper" style="position:relative">
								<label for="person_where" class="label-floatlabel">City, State, Province, or Zip</label>
								<input placeholder="" name="Where" value="" class="both-connect form-control float-label" style="width:200px;"" type="text" id="person_where">
							</div>
		                    <div class="js-clear-inputs input-group-addon" title="Clear fields">
			                    <span class="wp-icon-pro-x"></span>
		                    </div>
		                    <div style="display:table-cell;vertical-align:middle;padding-left:3px;">
			                    <button name="button" type="submit" class="btn btn-info find">
					                <span class="wp-icon-pro wp-icon-pro-search"></span>&nbsp;Search
					            </button>
				            </div>
						</div>
					</div>
	            </div>
	            
	 
	        </div>
	    </div>
	</form>
	 
	 <c:set var="isPost">${httpMethod eq "POST"}</c:set>
	 <c:choose>
		 <c:when test="${exception ne null}">
		 	<div>EXCEPTION: ${exception.toString()}</div>
		 </c:when>
	 </c:choose>
	 
	 <c:choose>
	 	<c:when test='${isPost}'>
	 		<%-- first check the response messages --%>
			<c:choose>
			 	<c:when test="${messages != null && messages.size() > 0}">
			 		<c:forEach var="message" items="${messages}">
			 			<p>${message.toString()}</p>
			 		</c:forEach>	 		
			 	</c:when>
			</c:choose>
	 		<c:choose>
				<c:when test="${isSuccess}">
					<h1>${persons.size()} results returned.</h1>
					<%-- next start to output the person --%>
					<c:forEach items="${persons}" var="personModel">
						    <div class="col-md-4">
		                        <div class="result-box">
		                            <header>Person</header>
		                            <div class="person last">
		                                <h3 class="search person-name">
		                                    <c:out value="${personModel.getName()}"/>
		                                </h3>
		                                <div class="attr age-range">
		                                    <span class="attrname age-range">Age Range:</span>
		                                    <span class="attrvalue  age-range">${personModel.getAgeRange()}</span>
		                                </div>
		                                <div class="attr gender">
		                                    <span class="attrname gender">Gender:</span>
		                                    <span class="attrvalue  gender">${personModel.getGender()}</span>
		                                </div>
		                                <div class="attr linked-to-phone">
		                                    <span class="attrname linked-to-phone">Linked to Phone:</span>
		                                    <span class="attrvalue  linked-to-phone">${personModel.getLinkedToPhone()}</span>
		                                </div>
		                                <div class="attr linked-to-address">
		                                    <span class="attrname linked-to-address">Linked to Address:</span>
		                                    <span class="attrvalue  linked-to-address">${personModel.getLinkedToAddress()}</span>
		                                </div>
		                                <p/>
		                                <div class="related-people attr">
		                                    <div class="attrname">
		                                        <span class="translation_missing">Associated People</span>
		                                    </div>
		                                    <c:choose>
			                                    	<c:when test="${personModel.getAssociatedPeople().size() eq 0}">
			                                    		<div>None</div>
			                                    	</c:when>
		                                    	<c:otherwise>
				                                    	
				                                    <ul class="list-inline list-unstyled">
					                                    <c:forEach items="${personModel.getAssociatedPeople()}" var="associatedPerson">
					                                        <li>
					                                            ${associatedPerson.getName()}&nbsp;
					                                        </li>
				                                        </c:forEach>
				                                    </ul>
				                                </c:otherwise>
		                                    </c:choose>
		                                    <p/>
		                                </div>
		                                <div class="person-addresses-container">
		                                    <div class="toggle">
		                                        <span class="title">All Addresses (${personModel.getAddresses().size()})</span>
		                                    </div>
		                                    <p/>
		                                    <div class="addresses">
		                                    	<c:forEach var="address" items="${personModel.getAddresses()}">
			                                        <div class="address">
			                                            <div class="date-range">${address.getValidFor()}</div>
			                                            <p class="search">
			                                                    ${address.getHtml()}
			                                            </p>
			                                        </div>
			                                        
		                                        </c:forEach>
		                                        
		                                    </div>
		                                </div>
		                            </div>
		                        </div>
		                    </div>
		                    <div class="col-md-8">
		                        <div class="result-box big">
		                            <div class="row">
		                                <div class="col-md-6 left">
		                                    <header>Address</header>
		                                    <c:choose>
			                                    <c:when test="${personModel.getCurrentAddress() ne null}">
				                                    <div class="location" data-result-type="location">
				                                        <p class="search location">
				                                            
				                                            ${personModel.getCurrentAddress().getHtml()}
				                                                 
				                                        </p>
				                                        <div class="attr receiving-mail">
				                                            <span class="attrname receiving-mail">Receiving Mail:</span>
				                                            <span class="attrvalue attrsafe receiving-mail">${personModel.getCurrentAddress().getIsReceivingMail()}</span>
				                                        </div>
				                                        <div class="attr usage">
				                                            <span class="attrname usage">Usage:</span>
				                                            <span class="attrvalue  usage">${personModel.getCurrentAddress().getUsage()}</span>
				                                        </div>
				                                        <div class="attr delivery-point">
				                                            <span class="attrname delivery-point">Delivery Point:</span>
				                                            <span class="attrvalue attrsafe delivery-point">${personModel.getCurrentAddress().getDeliveryPoint()}</span>
				                                        </div>
				
				                                    </div>
				                            	</c:when>
				                            </c:choose>
		                                </div>
		                                <div class="col-md-6 right">
		                                    <header>Phone</header>
		                                    <c:choose>
		                                    	<c:when test="${personModel.getPhone() ne null}">
				                                    <div data-result-type="phone">
				                                        <div class="search phone-number">
				                                                ${personModel.getPhone().getPhoneNumber()}&nbsp;
				                                            
				                                        </div>
				                                        <div class="attr">
				                                            <span class="attrname do-not-call-registry">Do Not Call Registry:</span>
				                                            <span class="attrvalue do-not-call-registry">${personModel.getPhone().getDoNotCall()}</span>
				                                        </div>
				                                    </div>
			                                    </c:when>
			                                    <c:otherwise>
			                                    	<div>No information</div>
			                                    </c:otherwise>
											</c:choose>
		                                    <br />
		                                </div>
		                            </div>
		                        </div>
		                    </div>
		                <hr/>
		            </c:forEach>
				</c:when>
				<c:otherwise>
					<div>The API call did not return a response.</div>
			 	</c:otherwise>
			</c:choose>
	 	</c:when>
	 </c:choose>
</body>
</html>