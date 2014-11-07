// ***********************************************************************
// Assembly         : WebService
// Author           : Kushal Shah
// Created          : 08-06-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-06-2014
// ***********************************************************************
// <copyright file="WhitePagesWebService.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>WhitePagesWebService having method to execute the web requests.</summary>
// ***********************************************************************

using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Utilities;
using System.Globalization;

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
            statusDescription = WhitePagesConstants.ErrorStatusDescription;
            errorMessage = WhitePagesConstants.UnknownErrorMessage;

            try
            {
                string requestType = string.Empty;
                RequestData requestData = new RequestData();

                string authorization = requestDataNameValues["authorization"];
                requestDataNameValues.Remove("authorization");

                // Gets WhitePages phone lookup request URL and requestType.
                string request = requestData.GetWhitePagesPhoneLookupRequest(ref requestType);

                // Gets requested data for peron lookup API.
                string requestDataString = requestData.GetRequestData(requestType, requestDataNameValues);

                HttpWebRequest httpRequest = null;

                // Creating HttpWebRequest for Get and Post method. 
                switch (requestType)
                {
                    case WhitePagesConstants.GetMethod:
                        request += requestDataString;

                        // Creating HttpWebRequest.
                        httpRequest = WebRequest.Create(request) as HttpWebRequest;

                        // Set method type to GET
                        httpRequest.Method = WhitePagesConstants.GetMethod;
                        httpRequest.ContentType = "application/json";

                        if (!string.IsNullOrEmpty(authorization))
                        {
                            httpRequest.Headers["Authorization"] = authorization;
                        }

                        break;

                    case WhitePagesConstants.PostMethod:

                        // Creating HttpWebRequest.
                        httpRequest = WebRequest.Create(request) as HttpWebRequest;

                        // Set method type to POST
                        httpRequest.Method = WhitePagesConstants.PostMethod;

                        // set ContentType to HttpWebRequest
                        httpRequest.ContentType = "application/json";

                        if (!string.IsNullOrEmpty(authorization))
                        {
                            httpRequest.Headers["Authorization"] = authorization;
                        }

                        string postData = requestDataString;

                        // Convert Post Data to byte.
                        byte[] postBytes = new ASCIIEncoding().GetBytes(postData);

                        // Set ContentLength
                        httpRequest.ContentLength = postBytes.Length;

                        Stream requestStream = httpRequest.GetRequestStream();
                        requestStream.Write(postBytes, 0, postBytes.Length);
                        requestStream.Close();

                        break;
                    default:
                        // do the default action
                        break;
                }

                HttpWebResponse response = httpRequest.GetResponse() as HttpWebResponse;

                statusCode = Convert.ToInt32(response.StatusCode, CultureInfo.CurrentCulture);
                statusDescription = response.StatusDescription;
                errorMessage = string.Empty;

                // Get response stream.
                responseStream = response.GetResponseStream();
            }
            // Handles WebException if occurs.
            catch (WebException webException)
            {
                try
                {
                    HttpWebResponse webResponse = webException.Response as HttpWebResponse;

                    if (webResponse != null)
                    {
                        statusCode = Convert.ToInt32(webResponse.StatusCode, CultureInfo.CurrentCulture);
                        statusDescription = webResponse.StatusDescription;

                        Stream stream = webResponse.GetResponseStream();
                        using (StreamReader streamReader = new StreamReader(stream))
                        {
                            string textErrorMessage = streamReader.ReadToEnd();
                            errorMessage = textErrorMessage;
                        }
                    }
                    else
                    {
                        statusCode = Convert.ToInt32(webException.Status, CultureInfo.CurrentCulture);
                        statusDescription = WhitePagesConstants.WebExceptionStatusMessageText + webException.Message;
                        errorMessage = webException.StackTrace;
                    }
                }
                catch (Exception ex)
                {
                    statusDescription = WhitePagesConstants.ExceptionStatusDescription;
                    errorMessage = ex.Message;
                }
            }
            catch (Exception ex)
            {
                statusDescription = WhitePagesConstants.ExceptionStatusDescription;
                errorMessage = ex.Message;
            }

            return responseStream;
        }
    }
}
