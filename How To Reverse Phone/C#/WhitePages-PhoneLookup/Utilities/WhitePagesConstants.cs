using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class WhitePagesConstants
    {
	    // Need to specify the API key to access data from WhatPages API. This is mandatory.
        public const string ApiKey = "";

        public const string PeopleDataTemplates = "<p>"+
            ":PEOPLE_NAME"+
            "</p>"+
            "<p>"+
            "<span>Type:</span>"+
            ":TYPE"+
            "</p><br />";

        public const string LocationDataTemplates = "<p>" +
            ":ADDRESS" +
            "</p>" +
            "<p>" +
            "<span>Receiving mail:</span>" +
            ":RECEIVING_MAIL" +
            "</p>" +
            "<p>" +
            "<span>Usage:</span>" +
            ":USAGE" +
            "</p>" +
            "<p>" +
            "<span>Delivery Point:</span>" +
            ":DELIVERY_POINT" +
            "</p>" +
            "<br />";

        public const string PersonDataTemplates ="<div class='detail_boxin'>"+
            "<p>:PERSON_NAME</p>"+
            "<p><span>Type:</span>  :PERSON_TYPE</p>"+
            "</div>";
    }
}
