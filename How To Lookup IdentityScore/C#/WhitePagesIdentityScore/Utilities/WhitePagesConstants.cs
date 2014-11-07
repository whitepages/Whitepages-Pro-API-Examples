// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 08-12-2014
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

        // Html Templates for component IdentityScore.
        public const string IdentityScoreDataTemplates = @"<tr>
                            <td>
                                <p>:SCORE_NAME</p>
                            </td>
                            <td>
                                <p>:SCORE</p>
                            </td>
                        </tr>";

        // Html Templates for IdentityScoreData result.
        public const string IdentityScoreDataBox = @"<div class='disp_result_box'>
                    <table width='100%' border='0' cellspacing='0' cellpadding='0'>
                        <tr>
                            <th align='left' width='30%'>Score Name</th>
                            <th align='left' width='30%'>Score</th>
                        </tr>
                        :IDENTITY_SCORE_RESULT
                    </table>
                </div>";

        public const string UnknownErrorMessage = "Unknown error has occured.";
        public const string ErrorStatusDescription = "Unknown";
        public const string GetMethod = "GET";
        public const string PostMethod = "POST";
        public const string WebExceptionStatusMessageText = "WebException Status Message =>";
        public const string ExceptionStatusDescription = "ExceptionOccurred";

        public const string NameNotProvidedMessage = "Please enter name.";
        public const string BillingAddressStreetLine1NotProvidedMessage = "Please enter billing address street line1.";
        public const string BillingAddressCityNotProvidedMessage = "Please enter billing address city.";
        public const string BillingAddressStateCodeNotProvidedMessage = "Please enter billing address state code.";
        public const string BillingPhoneNotProvidedMessage = "Please enter billing phone.";
        public const string IPAddressNotProvidedMessage = "Please enter ip address.";
        public const string EmailAddressNotProvidedMessage = "Please enter email address.";
        public const string ParsingErrorMessage = "Could not parse Identity Score Data.";
        public const string NullDataFromWhitePagesErrorMessage = "Could not get data from WhitePages.";
        public const string NAText = "NA";
        
        /*********************************************************************/
    }
}
