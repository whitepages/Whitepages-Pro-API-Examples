// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 11-06-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-06-2014
// ***********************************************************************
// <copyright file="Location.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>To keep the location information after parsing the result of phone lookup.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class Location
    {
        public string Address { get; set; }

        public string ReceivingMail { get; set; }

        public string Usage { get; set; }

        public string DeliveryPoint { get; set; }
    }
}
