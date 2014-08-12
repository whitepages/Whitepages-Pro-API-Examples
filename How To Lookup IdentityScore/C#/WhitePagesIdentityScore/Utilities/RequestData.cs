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
        /// <returns>returns WhitePages request Url</returns>
        public string GetWhitePagesRequest(ref string requestType)
        {
            string whitePagesRequestUrl = string.Empty;

            whitePagesRequestUrl = ServerApis.WhitePagesIdentityScoreApi;
            requestType = GetRequest;

            return whitePagesRequestUrl;
        }

        /// <summary>
        /// This method get request data for GET/POST requestType.
        /// </summary>
        /// <param name="requestType">requestType i.e GET/POST</param>
        /// <param name="nameValues">Parameters NameValueCollection</param>
        /// <returns>requestData for Get/Post</returns>
        public string GetRequestData(string requestType, NameValueCollection nameValues)
        {
            string requestData = string.Empty;

            foreach (string key in nameValues.AllKeys)
            {
                if (!string.IsNullOrEmpty(requestData))
                {
                    if (requestType.Equals(GetRequest))
                    {
                        requestData += "&";
                    }
                    else if (requestType.Equals(PostRequest))
                    {
                        requestData += ", ";
                    }
                }

                if (requestType.Equals(GetRequest))
                {
                    requestData += key + "=" + nameValues[key];
                }
                else if (requestType.Equals(PostRequest))
                {
                    requestData += '"' + key + '"' + ":" + '"' + nameValues[key] + '"';
                }
            }

            if (requestType.Equals(GetRequest))
            {
                requestData = "?" + requestData;
            }
            else if (requestType.Equals(PostRequest))
            {
                requestData = "{" + requestData + "}";
            }

            return requestData;
        }
    }
}
