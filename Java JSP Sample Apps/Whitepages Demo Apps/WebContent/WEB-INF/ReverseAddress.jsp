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
<title>Reverse Address - Whitepages Pro API Demo</title>
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
	<h1>Reverse Address</h1>
	<c:choose>
		<c:when test="${exception ne null}">
			<div>
				EXCEPTION: ${exception.toString()}
			</div>
		</c:when>
	</c:choose>
	
	<form action="${root}/ReverseAddressServlet" method="POST">
		<div class="row">
	        <div class="col-md-12 tab-content">
	            <div class="inner tab-pane active">
	                <div class="form-group">
	                    <div class="floatlabel-wrapper" style="position: relative">
	                        <label for="person_address" class="label-floatlabel">Street Address</label>
	                        <input placeholder="Street Address" name="Address" value="" class="both-connect form-control float-label"
	                               type="text" id="person_address">
	                    </div>
	                </div>
	                <div class="form-group form-group-last">
	                    <div class="input-group">
	                        <div class="floatlabel-wrapper" style="position: relative">
	                            <label for="person_where" class="label-floatlabel">City, State, or ZIP</label>
	                            <input placeholder="City, State, or ZIP" name="Where" value="" style="width:200px;" class="both-connect form-control float-label"
	                                   type="text" id="person_where">
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
					<h1>${addresses.size()} results returned.</h1>
					<c:forEach items="${addresses}" var="address">
						<div class="col-md-4">
                            <div class="result-box" data-section="location">
                                <div class="location" data-result-type="location">
                                    <p class="search location">
                                        ${address.getHtml()}
                                </p>
                                <div class="attr receiving-mail">
                                    <span class="attrname usage">Receiving Mail:</span>
                                    <span class="attrvalue  usage">
                                        ${address.getIsReceivingMail()}
                                    </span>
                                </div>
                                <div class="attr usage">
                                    <span class="attrname usage">Usage:</span>
                                    <span class="attrvalue  usage">
                                        ${address.getUsage()}
                                    </span>
                                </div>
                                <div class="attr delivery-point">
                                    <span class="attrname delivery-point">Delivery Point:</span>
                                    <span class="attrvalue attrsafe delivery-point">
                                        ${address.getDeliveryPoint()}
                                    </span>
                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="result-box" data-section="person">
                            <header>People</header>
                            <c:forEach items="${address.getPersonAssociations()}" var="person">
								<div class="person" data-result-type="person">
								    <h3 class="search person-name">
								        ${person.getName()}&nbsp;
								    </h3>
								    <div class="attr age-range">
								        <span class="attrname age-range">Age Range:</span>
								        <span class="attrvalue age-range">${person.getAgeRange()}</span>
								    </div>
								    <div class="attr gender">
								        <span class="attrname gender">Gender:</span>
								        <span class="attrvalue  gender">${person.getGender()}</span>
								    </div>
								    <div class="attr linked-to-phone">
								        <span class="attrname linked-to-phone">Linked to Phone:</span>
								        <span class="attrvalue  linked-to-phone">${person.getLinkedToPhone()}</span>
								    </div>
								    <div class="attr linked-to-address">
								        <span class="attrname linked-to-address">Linked to Address:</span>
								        <span class="attrvalue  linked-to-address">${person.getLinkedToAddress()}</span>
					                </div>
					                <c:if test="${person.getPhone() ne null}">
                                        
                                        <div class="alternate-phone">
                                            <div class="attr alternate-phone">
                                                <span class="attrname alternate-phone">Alternate Phone:</span>
                                                <span class="attrvalue ">
                                                    ${person.getPhone().getPhoneNumber()}
                                                    <br/>
                                                    <span class="alternate-type">
														Line Type: ${person.getPhone().getLineType()}
													</span>
                                                </span>
                                            </div>
                                        </div>
                                    </c:if>
                                    <p/>
                                    <c:if test="${person.getAssociatedPeople().size() > 0}">
	                                    <div class="related-people attr">
	                                        <div class="attrname">
	                                            Associated People
	                                        </div>
	                                        <c:forEach items="${person.getAssociatedPeople()}" var="associate">
	                                            <ul class="list-inline list-unstyled">
	                                                <li>
	                                                    ${associate.getName()}&nbsp;
	                                                </li>
	                                            </ul>
	                                        </c:forEach>
	                                    </div>
	                                    <p/>
	                                </c:if>
                                    <c:if test="${person.getAddresses().size() > 0}">
	                                    <div class="person-addresses-container">
		                                    <div class="toggle">
		                                        <span class="title">Known Addresses</span>
		                                    </div>
		                                    <c:forEach items="${person.getAddresses()}" var="personAddress">
	                                                <div class="addresses">
	                                                   <div class="address highlighted">
	                                                       <div class="date-range">
	                                                               ${personAddress.getValidFor()}
	                                                       </div>
	                                                       <p class="search">
		                                                       ${personAddress.getHtml()}
	                                                       </p>
	                                                   </div>
	                                                </div>
	                                        </c:forEach>
	                                                
	                                    </div>
                                    </c:if>
                                </div>
                                <hr />
                                    
                            </c:forEach>

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