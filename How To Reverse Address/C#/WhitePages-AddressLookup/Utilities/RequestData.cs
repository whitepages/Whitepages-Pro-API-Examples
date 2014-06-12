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
        /// This method get learn ipc request based on ipc request.
        /// </summary>
        /// <param name="ipcRequest"></param>
        /// <param name="requestType"></param>
        /// <returns></returns>
        public string GetLeranIpcRequest(RequestApi requestApi, ref string requestType)
        {
            string ipcRequestUrl = string.Empty;

            switch (requestApi)
            {
                case RequestApi.Address:
                    ipcRequestUrl = ServerApis.WhitePapersAddressApi;
                    requestType = GetRequest;
                    break;
            }

            return ipcRequestUrl;
        }

        /// <summary>
        /// This method get request data for GET/POST requestType.
        /// </summary>
        /// <param name="nameValues">nameValues</param>
        /// <returns>requestData for GET/POST request.</returns>
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
