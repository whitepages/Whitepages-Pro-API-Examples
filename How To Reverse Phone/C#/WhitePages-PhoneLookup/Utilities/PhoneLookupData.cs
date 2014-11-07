// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 11-05-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-06-2014
// ***********************************************************************
// <copyright file="PhoneLookupData.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>After parsing the result we will keep all information to PhoneLookupData.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class PhoneLookupData
    {
        public string PhoneNumber { get; set; }

        public string Carrier { get; set; }

        public string PhoneType { get; set; }

        public string DndStatus { get; set; }

        public string SpamScore { get; set; }

        private People[] people;

        public People[] GetPeople()
        {
            return people;
        }

        public void SetPeople(People[] value)
        {
            people = value;
        }

        private Location[] location;

        public Location[] GetLocation()
        {
            return location;
        }

        public void SetLocation(Location[] value)
        {
            location = value;
        }
    }
}
