// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 11-04-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-06-2014
// ***********************************************************************
// <copyright file="AddressLookupData.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>After parsing the result we will keep all information to AddressLookupData.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class AddressLookupData
    {
        public string Address { get; set; }

        public string ReceivingMail { get; set; }

        public string Usage { get; set; }

        public string DeliveryPoint { get; set; }

        public int NoOfPerson { get; set; }

        private Person[] person;

        public Person[] GetPerson()
        {
            return person;
        }

        public void SetPerson(Person[] value)
        {
            person = value;
        }
    }
}
