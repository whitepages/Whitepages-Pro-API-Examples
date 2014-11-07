// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 08-06-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-06-2014
// ***********************************************************************
// <copyright file="WhitePagesConstants.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>WhitePagesConstants to keep all string resurces, API Key and html templates strings.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class WhitePagesConstants
    {
	    // Need to specify the API key to access data from WhatPages API. This is mandatory.
        public const string ApiKey = "";

        public const string PeopleDataTemplates = "<p>"+
            ":PEOPLE_NAME"+
            "</p>"+
            "<p>"+
            "<span>Type:</span>"+
            ":TYPE"+
            "</p><br />";

        public const string LocationDataTemplates = "<p>" +
            ":ADDRESS" +
            "</p>" +
            "<p>" +
            "<span>Receiving mail:</span>" +
            ":RECEIVING_MAIL" +
            "</p>" +
            "<p>" +
            "<span>Usage:</span>" +
            ":USAGE" +
            "</p>" +
            "<p>" +
            "<span>Delivery Point:</span>" +
            ":DELIVERY_POINT" +
            "</p>" +
            "<br />";

        public const string PersonDataTemplates ="<div class='detail_boxin'>"+
            "<p>:PERSON_NAME</p>"+
            "<p><span>Type:</span>  :PERSON_TYPE</p>"+
            "</div>";

        public const string UnknownErrorMessage = "Unknown error has occured.";
        public const string ErrorStatusDescription = "Unknown";
        public const string GetMethod = "GET";
        public const string PostMethod = "POST";
        public const string WebExceptionStatusMessageText = "WebException Status Message =>";
        public const string ExceptionStatusDescription = "ExceptionOccurred";

        public const string PhoneBlankInputMessage = "Please enter phone number";
        public const string RegisteredText = "Registered";
        public const string NotRegisteredText = "Not Registered";
        public const string PercentText = "%";
        public const string ZeroPercentText = "0%";
        public const string YesText = "Yes";
        public const string NoText = "No";

        public const string PeopleNameKey = ":PEOPLE_NAME";
        public const string TypeKey = ":TYPE";
        public const string AddressKey = ":ADDRESS";
        public const string ReceivingMailKey = ":RECEIVING_MAIL";
        public const string UageEKey = ":USAGE";
        public const string DeliveryPointKey = ":DELIVERY_POINT";
    }
}
