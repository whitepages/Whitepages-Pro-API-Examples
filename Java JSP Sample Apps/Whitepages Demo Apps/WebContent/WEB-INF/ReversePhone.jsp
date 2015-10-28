<%@ page language="java" 
	contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    trimDirectiveWhitespaces="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="root" value="${pageContext.request.contextPath}" />
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Reverse Phone - Whitepages Pro API Demo</title>
<link rel="stylesheet" href="${root}/css/Site.css" type="text/css"/>
</head>
<body>
<h1>Reverse Phone</h1>
	<c:choose>
		<c:when test="${exception ne null}">
			<div>
				EXCEPTION: ${exception.toString()}
			</div>
		</c:when>
	</c:choose>
	
	<form action="${root}/ReversePhoneServlet" method="POST" class="form-inline">
	<div class="row">
		<div class="col-md-12 tab-content">
			<div class="inner tab-pane active">
				
				<div class="form-group form-group-last">
					<div class="input-group input-group-last">
						<div class="floatlabel-wrapper" style="position: relative">
							<label for="lookup_number" class="label-floatlabel  " style="position: absolute; top: 0px; left: 8px; display: block; opacity: 1; font-size: 11px; font-weight: bold; color: rgb(131, 135, 128); transition: all 0.1s ease-in-out;">Phone Number</label>
							<input placeholder="Phone Number" name="phoneNumber" value="${param.phoneNmber}" class="form-control float-label active-floatlabel" type="tel" id="lookup_number" style="padding-top: 12px; width:200px;">
						</div>
						<div class="js-clear-inputs input-group-addon" title="Clear fields">
							<span class="wp-icon-pro-x"></span>
						</div>
						<div style="display:table-cell;vertical-align:middle;padding-left:3px;">
							<button name="button" type="submit" class="btn btn-info find">
								<span class="wp-icon-pro wp-icon-pro-search"></span>
								&nbsp;Search
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
	 <p/>
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
					<h1>${phones.size()} results returned.</h1>
					<c:forEach items="${phones}" var="phone">
						<div class="col-md-4">
                            <div class="result-box" data-section="location">
		                        <div data-result-type="phone">
									<header>Phone</header>
									<h3 class="search phone-number">${phone.getPhoneNumber()}</h3>
									<div class="attr carrier">
										<span class="attrname carrier">Carrier:</span> 
										<span class="attrvalue  carrier">${phone.getCarrier()}</span> 
									</div>
									<div class="attr phone-type">
										<span class="attrname phone-type">Phone Type:</span> 
										<span class="attrvalue attrsafe phone-type">${phone.getLineType()}</span> 
									</div>
									<div class="attr do-not-call-registry">
									    <span class="attrname do-not-call-registry">Do Not Call Registry:</span> 
		                                <span class="attrvalue  do-not-call-registry">${phone.getDoNotCall()}</span> 
									</div>
									<div class="attr spam-level">
									    <span class="attrname spam-level">Spam Level:</span> 
		                                <span class="attrvalue attrsafe spam-level">${phone.getReputationLevel()}</span> 
									</div>
									<div class="attr prepaid">
									    <span class="attrname prepaid">Prepaid:</span> 
		                                <span class="attrvalue  prepaid">${phone.getPrepaid()}</span> 
									</div>
								</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
						<div class="result-box">
							<header>Person</header>
							<c:if test="${phone.getPersonAssociations().size() > 0}">
								<div class="person last" data-result-type="person">
									<h3 class="search person-name">
										${phone.getPersonAssociations().get(0).getName()}&nbsp;
									</h3>
									<div class="attr age-range">
										<span class="attrname age-range">Age Range:</span> 
										<span class="attrvalue age-range">${phone.getPersonAssociations().get(0).getAgeRange()}</span> 
									</div>
									<div class="attr gender">
										<span class="attrname gender">Gender:</span> 
										<span class="attrvalue  gender">${phone.getPersonAssociations().get(0).getGender()}</span> 
									</div>
									<div class="attr linked-to-phone">
										<span class="attrname linked-to-phone">Linked to Phone:</span> 
										<span class="attrvalue  linked-to-phone">${phone.getPersonAssociations().get(0).getLinkedToPhone()}</span> 
									</div>
									<div class="attr linked-to-address">
										<span class="attrname linked-to-address">Linked to Address:</span> 
										<span class="attrvalue  linked-to-address">${phone.getPersonAssociations().get(0).getLinkedToAddress()}</span> 
									</div>
									<div class="person-addresses-container closed">
										<div class="toggle">
										    <span class="title">All Addresses (${phone.getPersonAssociations().get(0).getAddresses().size()})</span>
										    <p/>
										</div>
										<div class="addresses">
										<c:forEach items="${phone.getPersonAssociations().get(0).getAddresses()}" var="address">
											<div class="address highlighted">
												<div class="date-range">${address.getValidFor()}</div>
												<p class="search">
													${address.getHtml()}
												</p>
											</div>
										</c:forEach>
										</div>
									</div>
								
								</div>
							</c:if>
						</div>
					</div>
					<div class="col-md-4">
						<div class="result-box">
							<header>Address</header>
							<c:if test="${phone.getAddress() ne null}">
								<div class="location" data-result-type="location">
									<p class="search location">
										${phone.getAddress().getHtml()}
									</p>
									<div class="attr receiving-mail">
										<span class="attrname receiving-mail">Receiving Mail:</span> 
										<span class="attrvalue attrsafe receiving-mail">${phone.getAddress().getIsReceivingMail()}</span> 
									</div>
									<div class="attr usage">
										<span class="attrname usage">Usage:</span> 
										<span class="attrvalue  usage">${phone.getAddress().getUsage()}</span> 
									</div>
									<div class="attr delivery-point">
										<span class="attrname delivery-point">Delivery Point:</span> 
										<span class="attrvalue attrsafe delivery-point">${phone.getAddress().getDeliveryPoint()}</span> 
									</div>
								</div>
							</c:if>
						</div>

					</div>
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