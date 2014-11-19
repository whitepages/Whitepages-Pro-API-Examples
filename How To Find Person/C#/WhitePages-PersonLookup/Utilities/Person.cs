// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 11-13-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-13-2014
// ***********************************************************************
// <copyright file="Person.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>After parsing it will keep all information related to person.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class Person
    {
        public string AddressLine1 { get; set; }

        public string AddressLine2 { get; set; }

        public string AddressLocation { get; set; }

        public string AgeRange { get; set; }

        public string ContentType { get; set; }

        public string PersonName { get; set; }

        public bool ReceivingMail { get; set; }

        public string Usage { get; set; }

        public string DeliveryPoint { get; set; }
    }
}
