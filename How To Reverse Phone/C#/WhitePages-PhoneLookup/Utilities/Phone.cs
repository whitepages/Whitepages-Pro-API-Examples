// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 11-05-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-11-2014
// ***********************************************************************
// <copyright file="Phone.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>After parsing the result we will keep phone details.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class Phone
    {
        public string PhoneNumber { get; set; }

        public string CountryCallingCode { get; set; }

        public string Carrier { get; set; }

        public string PhoneType { get; set; }

        public bool DndStatus { get; set; }

        public string SpamScore { get; set; }
    }
}
