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


        /**********************  Messages to show on UI  *********************/

        public const string NameNotProvidedMessage = "Please enter name.";
        public const string BillingAddressStreetLine1NotProvidedMessage = "Please enter billing address street line1.";
        public const string BillingAddressCityNotProvidedMessage = "Please enter billing address city.";
        public const string BillingAddressStateCodeNotProvidedMessage = "Please enter billing address state code.";
        public const string BillingPhoneNotProvidedMessage = "Please enter billing phone.";
        public const string IpAddressNotProvidedMessage = "Please enter ip address.";
        public const string EmailAddressNotProvidedMessage = "Please enter email address.";
        public const string ParsingErrorMessage = "Could not parse Identity Score Data.";
        public const string NullDataFromWhitePagesErrorMessage = "Could not get data from WhitePages.";
        public const string NaText = "NA";
        
        /*********************************************************************/
    }
}
