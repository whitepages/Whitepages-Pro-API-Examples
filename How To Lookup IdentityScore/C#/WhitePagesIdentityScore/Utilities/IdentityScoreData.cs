using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WhitePagesIdentityScore
{
    public class IdentityScoreData
    {
        public string billingName { get; set; }

        public string shippingName { get; set; }

        public string streetLine1 { get; set; }

        public string city { get; set; }

        public string stateCode { get; set; }

        public string billingPhone { get; set; }

        public string ipAddress { get; set; }

        public string emailAddress { get; set; }

        public Components[] components { get; set; }
    }

    public class Components
    {
        public string scoreName { get; set; }

        public string score { get; set; }
    }
}