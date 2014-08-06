using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace WebService
{
    public class WhitePagesWebService
    {
        /// <summary>
        /// This method execute web request to get response.
        /// </summary>
        /// <param name="requestDataNameValues">requestDataNameValues</param>
        /// <param name="statusCode">statusCode</param>
        /// <param name="statusDescription">statusDescription</param>
        /// <param name="errorMessage">errorMessage</param>
        /// <returns>responseStream</returns>
        public Stream ExecuteWebRequest(NameValueCollection requestDataNameValues, ref int statusCode, ref string statusDescription, ref string errorMessage)
        {
            Stream responseStream = null;
            statusDescription = "Unknown";
            errorMessage = "Unknown error has occured.";
            try
            {
                string requestType = string.Empty;
                RequestData requestData = new RequestData();

                string authorization = requestDataNameValues["authorization"];
                requestDataNameValues.Remove("authorization");

                string request = requestData.GetWhitePagesRequest(ref requestType);
                string requestDataString = requestData.GetRequestData(requestType, requestDataNameValues);

                HttpWebRequest httpRequest = null;

                switch (requestType)
                {
                    case "GET":
                        request += requestDataString;
                        httpRequest = WebRequest.Create(request) as HttpWebRequest;
                        httpRequest.Method = "GET";
                        httpRequest.ContentType = "application/json";

                        if (!string.IsNullOrEmpty(authorization))
                        {
                            httpRequest.Headers["Authorization"] = authorization;
                        }

                        break;

                    case "POST":
                        httpRequest = WebRequest.Create(request) as HttpWebRequest;
                        httpRequest.Method = "POST";
                        httpRequest.ContentType = "application/json";

                        if (!string.IsNullOrEmpty(authorization))
                        {
                            httpRequest.Headers["Authorization"] = authorization;
                        }

                        string postData = requestDataString;

                        byte[] postBytes = new ASCIIEncoding().GetBytes(postData);
                        httpRequest.ContentLength = postBytes.Length;

                        Stream requestStream = httpRequest.GetRequestStream();
                        requestStream.Write(postBytes, 0, postBytes.Length);
                        requestStream.Close();

                        break;
                }

                HttpWebResponse response = httpRequest.GetResponse() as HttpWebResponse;

                statusCode = Convert.ToInt32(response.StatusCode);
                statusDescription = response.StatusDescription;
                errorMessage = string.Empty;

                // Get response stream
                responseStream = response.GetResponseStream();

                // Dispose the response stream.
                //responseStream.Dispose();
            }
            catch (WebException webException)
            {
                try
                {
                    HttpWebResponse webResponse = webException.Response as HttpWebResponse;

                    if (webResponse != null)
                    {
                        statusCode = Convert.ToInt32(webResponse.StatusCode);
                        statusDescription = webResponse.StatusDescription;

                        Stream stream = webResponse.GetResponseStream();
                        StreamReader streamReader = new StreamReader(stream);
                        string textErrorMessage = streamReader.ReadToEnd();
                        errorMessage = textErrorMessage;
                    }
                    else
                    {
                        statusCode = Convert.ToInt32(webException.Status);
                        statusDescription = "WebException Status Messgae =>" + webException.Message;
                        errorMessage = webException.StackTrace;
                    }
                }
                catch (Exception ex)
                {
                    statusDescription = "ExceptionOccurred";
                    errorMessage = ex.Message;
                }
            }
            catch (Exception ex)
            {
                statusDescription = "ExceptionOccurred";
                errorMessage = ex.Message;
            }

            return responseStream;
        }
    }
}
