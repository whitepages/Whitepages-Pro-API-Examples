// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 08-12-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-06-2014
// ***********************************************************************
// <copyright file="IdentityScoreData.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>After parsing the result we will keep all information to IdentityScoreData.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Utilities
{
    public class IdentityScoreData
    {
        public string BillingName { get; set; }

        public string ShippingName { get; set; }

        public string StreetLine1 { get; set; }

        public string City { get; set; }

        public string StateCode { get; set; }

        public string BillingPhone { get; set; }

        public string IPAddress { get; set; }

        public string EmailAddress { get; set; }

        private Components[] components;

        public Components[] GetComponents()
        {
            return components;
        }

        public void SetComponents(Components[] value)
        {
            components = value;
        }
    }
}