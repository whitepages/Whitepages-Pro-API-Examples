using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class WhitepapersConstants
    {
        public const string ApiKey = "";

        public const string ageSection = "<p><span>Age:</span> :AGE</p>";

        public const string PersonDataTemplates = "<tr>"+
                            "<td>"+
                                "<p>:FULL_NAME</p>"+
                                ":AGE"+
                                "<p><span>Type:</span> :TYPE </p>"+
                            "</td>"+
                            "<td>"+
                                "<p>:FULL_ADDRESS</p>"+
                                "<p><span>Receiving Mail:</span> :RECEIVING_MAIL </p>" +
                                "<p><span>Usage:</span> :USAGE </p>" +
                                "<p>"+
                                    "<span>Delivery Point:</span>"+
                                    ":DELIVERY_POINT" +
                                "</p>"+
                            "</td>"+
                        "</tr>";
    }
}
