// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 11-11-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-11-2014
// ***********************************************************************
// <copyright file="Result.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>After parsing the result we will keep phone, location and people details.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class Result
    {
        public Phone Phone { get; set; }

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
