// ***********************************************************************
// Assembly         : Utilities
// Author           : Kushal Shah
// Created          : 08-06-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-05-2014
// ***********************************************************************
// <copyright file="RequestData.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>RequestData class having method to provide phone lookup request URL and create the request data.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Utilities
{
    public class RequestData
    {
        // Request Type
        private const string GetRequest = "GET";
        private const string PostRequest = "POST";

        /// <summary>
        /// This method get WhitePages API request Url.
        /// </summary>
        /// <param name="requestType">API Request Type will return as a ref parameter</param>
        /// <returns>returns WhitePages phone lookup request Url</returns>
        public string GetWhitePagesPhoneLookupRequest(ref string requestType)
        {
            string whitePagesPhoneLookupRequestUrl = string.Empty;

            whitePagesPhoneLookupRequestUrl = ServerApis.WhitePagesPhoneLookupApi;
            requestType = GetRequest;

            return whitePagesPhoneLookupRequestUrl;
        }

        /// <summary>
        /// In this method we creates API request data based on request type i.e. GET or POST, 
        /// in NameValueCollection param we gets all parameter for API.
        /// </summary>
        /// <param name="requestType">requestType i.e GET/POST</param>
        /// <param name="nameValues">Parameters NameValueCollection</param>
        /// <returns>requestData for Get/Post</returns>
        public string GetRequestData(string requestType, NameValueCollection nameValues)
        {
            string requestData = string.Empty;

            // Reading all parameter from NameValueCollection and creates request data.
            foreach (string key in nameValues.AllKeys)
            {
                // Here checking requestData is empty to skip first titration to put '&' for GET request and ',' for POST request.
                if (!string.IsNullOrEmpty(requestData))
                {
                    // Here we check the request type either GET or POST and we add the '&' separator for paramaters for GET 
                    // and ',' for POST to create JSON data.
                    if (requestType.Equals(GetRequest, StringComparison.CurrentCulture))
                    {
                        requestData += "&";
                    }
                    else if (requestType.Equals(PostRequest, StringComparison.CurrentCulture))
                    {
                        requestData += ", ";
                    }
                }

                // Concatenating request parameters key and value here.
                if (requestType.Equals(GetRequest, StringComparison.CurrentCulture))
                {
                    requestData += key + "=" + nameValues[key];
                }
                else if (requestType.Equals(PostRequest, StringComparison.CurrentCulture))
                {
                    requestData += '"' + key + '"' + ":" + '"' + nameValues[key] + '"';
                }
            }

            // Adding prefix '?' for GET method and prefix/postfix '{' / '}' for POST method.
            if (requestType.Equals(GetRequest, StringComparison.CurrentCulture))
            {
                requestData = "?" + requestData;
            }
            else if (requestType.Equals(PostRequest, StringComparison.CurrentCulture))
            {
                requestData = "{" + requestData + "}";
            }

            return requestData;
        }
    }
}
