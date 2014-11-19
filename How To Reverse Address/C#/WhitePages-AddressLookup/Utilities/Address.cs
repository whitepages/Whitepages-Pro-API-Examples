// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 11-13-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-13-2014
// ***********************************************************************
// <copyright file="Address.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>After parsing the result we will keep address details.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class Address
    {
        public string AddressLine1 { get; set; }

        public string AddressLine2 { get; set; }

        public string AddressLocation { get; set; }

        public bool ReceivingMail { get; set; }

        public string Usage { get; set; }

        public string DeliveryPoint { get; set; }

        public int NoOfPerson { get; set; }
    }
}
