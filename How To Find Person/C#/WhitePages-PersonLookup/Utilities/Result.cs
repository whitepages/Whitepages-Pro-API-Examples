// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 11-13-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-13-2014
// ***********************************************************************
// <copyright file="Result.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>After parsing the result we will keep all information.</summary>
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
