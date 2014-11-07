// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 08-06-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-04-2014
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

        public const string AgeSection = "<p><span>Age:</span> :AGE</p>";

        public const string PersonDataTemplates = "<tr>"+
                            "<td>"+
                                "<p>:FULL_NAME</p>"+
                                ":AGE"+
                                "<p><span>Type:</span> :TYPE </p>"+
                            "</td>"+
                            "<td>"+
                                "<p>:FULL_ADDRESS</p>"+
                                "<p><span>Receiving Mail:</span> :RECEIVING_MAIL </p>" +
                                "<p><span>Usage:</span> :USAGE </p>" +
                                "<p>"+
                                    "<span>Delivery Point:</span>"+
                                    ":DELIVERY_POINT" +
                                "</p>"+
                            "</td>"+
                        "</tr>";

        public const string UnknownErrorMessage = "Unknown error has occured.";
        public const string ErrorStatusDescription = "Unknown";
        public const string GetMethod = "GET";
        public const string PostMethod = "POST";
        public const string WebExceptionStatusMessageText = "WebException Status Message =>";
        public const string ExceptionStatusDescription = "ExceptionOccurred";
        public const string NoResultMessage = "No result found.";

        public const string FirstNameBalnkInputMessage = "Please enter first name.";
        public const string LastNameBalnkInputMessage = "Last name value must be at least 1 characters";
        public const string LocationBalnkInputMessage = "Location value must be at least 1 characters";
        public const string AgeKey = ":AGE";
        public const string FullNameKey = ":FULL_NAME";
        public const string FullAddressKey = ":FULL_ADDRESS";
        public const string ReceivingMailKey = ":RECEIVING_MAIL";
        public const string UsageKey = ":USAGE";
        public const string DeliveryPointKey = ":DELIVERY_POINT";
        public const string TypeKey = ":TYPE";
        public const string YesText = "Yes";
        public const string NoText = "No";
    }
}
