// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 11-04-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-06-2014
// ***********************************************************************
// <copyright file="PersonLookupData.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>After parsing the result we will keep all information to PersonLookupData.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class PersonLookupData
    {
        public string AgeSection { get; set; }

        public string ContentType { get; set; }

        public string Address { get; set; }

        public string PersonName { get; set; }

        public string ReceivingMail { get; set; }

        public string Usage { get; set; }

        public string DeliveryPoint { get; set; }
    }
}
