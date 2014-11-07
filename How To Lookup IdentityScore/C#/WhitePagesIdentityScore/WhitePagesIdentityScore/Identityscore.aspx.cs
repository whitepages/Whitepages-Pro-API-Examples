// ***********************************************************************
// Assembly         : WhitePagesIdentityScore
// Author           : Kushal Shah
// Created          : 08-12-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-06-2014
// ***********************************************************************
// <copyright file="Identityscore.aspx.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>IdentityScore class is code behind of Identityscore page.</summary>
// ***********************************************************************

using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Utilities;
using WebService;

namespace WhitePagesIdentityScore
{
    public partial class IdentityScore : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                errorDiv.Visible = false;
                identityScoreResult.Visible = false;
            }
        }

        /// <summary>
        /// Click event of Find button. Find button event occurs when user clicks on find button.
        /// get data from WhitePages identity_score API and show on UI.
        /// </summary>
        /// <param name="sender">Object sender</param>
        /// <param name="e">event data.</param>
        protected void ButtonFindClick(object sender, EventArgs e)
        {
            errorDiv.Visible = false;
            LitralErrorMessage.Text = string.Empty;

            // Calling ValidateInput method to validate user's input.
            bool isInputValidated = ValidateInput();

            if (!isInputValidated)
            {
                identityScoreResult.Visible = false;
                errorDiv.Visible = true;
                return;
            }

            int statusCode = -1;
            string description = string.Empty;
            string errorMessage = string.Empty;

            NameValueCollection nameValues = new NameValueCollection();

            nameValues["name"] = name.Text;
            nameValues["billing_address_street_line_1"] = billing_address_street_line_1.Text;
            nameValues["billing_address_city"] = billing_address_city.Text;
            nameValues["billing_address_state_code"] = billing_address_state_code.Text;
            nameValues["billing_phone"] = billing_phone.Text;
            nameValues["ip_address"] = ip_address.Text;
            nameValues["email_address"] = email_address.Text;

            nameValues["api_key"] = WhitePagesConstants.ApiKey;

            WhitePagesWebService webService = new WhitePagesWebService();
            Stream responseStream = webService.ExecuteWebRequest(nameValues, ref statusCode, ref description, ref errorMessage);

            if (statusCode == 200 && responseStream != null)
            {
                StreamReader reader = new StreamReader(responseStream);
                string responseInJson = reader.ReadToEnd();

                // Dispose the response stream.
                responseStream.Dispose();

                // Calling ParseIdentityScoreResult to parse the response JSON in data class IdentityScoreData
                List<IdentityScoreData> identityScoreDataList = ParseIdentityScoreResult(responseInJson);

                if (identityScoreDataList != null && identityScoreDataList.Count > 0)
                {
                    // Calling function to populate data on UI.
                    PopulateDataOnUI(identityScoreDataList);
                }
                else
                {
                    identityScoreResult.Visible = false;
                    errorDiv.Visible = true;
                    LitralErrorMessage.Text = WhitePagesConstants.ParsingErrorMessage;
                }
            }
            else
            {
                if (statusCode == 200)
                {
                    LitralErrorMessage.Text = WhitePagesConstants.NullDataFromWhitePagesErrorMessage;
                }
                else
                {
                    LitralErrorMessage.Text = errorMessage;
                }

                this.identityScoreResult.Visible = false;
                this.errorDiv.Visible = true;
            }
        }

        /// <summary>
        /// This method validates user's input.
        /// </summary>
        /// <returns>isInputValidated</returns>
        private bool ValidateInput()
        {
            bool isInputValidated = true;

            if ((string.IsNullOrEmpty(name.Text)) && isInputValidated == true)
            {
                this.errorDiv.Visible = true;
                this.LitralErrorMessage.Text = WhitePagesConstants.NameNotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(billing_address_street_line_1.Text) && isInputValidated == true)
            {
                this.errorDiv.Visible = true;
                this.LitralErrorMessage.Text = WhitePagesConstants.BillingAddressStreetLine1NotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(billing_address_city.Text) && isInputValidated == true)
            {
                this.errorDiv.Visible = true;
                this.LitralErrorMessage.Text = WhitePagesConstants.BillingAddressCityNotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(billing_address_state_code.Text) && isInputValidated == true)
            {
                this.errorDiv.Visible = true;
                this.LitralErrorMessage.Text = WhitePagesConstants.BillingAddressStateCodeNotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(billing_phone.Text) && isInputValidated == true)
            {
                this.errorDiv.Visible = true;
                this.LitralErrorMessage.Text = WhitePagesConstants.BillingPhoneNotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(ip_address.Text) && isInputValidated == true)
            {
                this.errorDiv.Visible = true;
                this.LitralErrorMessage.Text = WhitePagesConstants.IPAddressNotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(email_address.Text) && isInputValidated == true)
            {
                this.errorDiv.Visible = true;
                this.LitralErrorMessage.Text = WhitePagesConstants.EmailAddressNotProvidedMessage;
                isInputValidated = false;
            }

            return isInputValidated;
        }

        /// <summary>
        /// This method populates data on UI.
        /// </summary>
        /// <param name="identityScoreDataList">identityScoreDataList</param>
        private void PopulateDataOnUI(List<IdentityScoreData> identityScoreDataList)
        {
            string identityScoreDataTemplates = WhitePagesConstants.IdentityScoreDataTemplates;

            string identityScoreDataString = string.Empty;

            // Creating template for identity score to show on UI.
            foreach(IdentityScoreData identityScoreData in identityScoreDataList)
            {
                string componentDataString = string.Empty;
                string identityScoreDataBox = WhitePagesConstants.IdentityScoreDataBox;

                foreach(Components component in identityScoreData.GetComponents())
                {
                    identityScoreDataTemplates = WhitePagesConstants.IdentityScoreDataTemplates;

                    // get score, score name and bind with template.
                    identityScoreDataTemplates = identityScoreDataTemplates.Replace(":SCORE_NAME", component.ScoreName);
                    identityScoreDataTemplates = identityScoreDataTemplates.Replace(":SCORE", string.IsNullOrEmpty(component.Score) ? WhitePagesConstants.NAText : component.Score);

                    componentDataString += identityScoreDataTemplates;
                }

                identityScoreDataString += identityScoreDataBox.Replace(":IDENTITY_SCORE_RESULT", componentDataString);
            }

            this.identityScoreResult.Visible = true;

            // Final template string is binding to LiteralIdentityScoreResult.
            this.LiteralIdentityScoreResult.Text = identityScoreDataString;
        }
        
        /// <summary>
        /// This method parse the Identity Score data to class IdentityScoreData.
        /// </summary>
        /// <param name="responseInJson">responseInJson</param>
        /// <returns>List<IdentityScoreData></returns>
        private List<IdentityScoreData> ParseIdentityScoreResult(string responseInJson)
        {
            // Creating list of IdentityScoreData class.
            List<IdentityScoreData> identityScoreDataList = new List<IdentityScoreData>();

            try
            {
                List<string> identityScoreResultKeyList = new List<string>();

                // responseInJson to DeserializeObject
                dynamic jsonObject = JsonConvert.DeserializeObject(responseInJson);

                // Creating list of all result key.
                foreach (var data in jsonObject.results)
                {
                    identityScoreResultKeyList.Add(data.Value);
                }

                if (identityScoreResultKeyList.Count > 0)
                {
                    // Extarct the dictionary object.
                    dynamic identityScoreDictionaryObj = jsonObject.dictionary;

                    IdentityScoreData identityScoreData = null;

                    // For every result key we will collect the IdentityScoreData meaning score and score name for each component.
                    foreach (string identityScoreKey in identityScoreResultKeyList)
                    {
                        identityScoreData = new IdentityScoreData();

                        dynamic identityScoreObject = identityScoreDictionaryObj[identityScoreKey];

                        // Extact request object
                        dynamic identityScoreRequestObj = identityScoreObject.request;

                        // Extact billing_name object
                        dynamic billingNameObj = identityScoreRequestObj.billing_name;

                        // Extact shipping_name object
                        dynamic shippingNameObj = identityScoreRequestObj.shipping_name;

                        // Extact billing_address object
                        dynamic billingAddressObj = identityScoreRequestObj.billing_address;

                        identityScoreData.BillingName = billingNameObj == null ? string.Empty : (string)billingNameObj["name"];
                        identityScoreData.ShippingName = shippingNameObj == null ? string.Empty : (string)shippingNameObj["name"];
                        identityScoreData.BillingPhone = (string)identityScoreRequestObj["billing_phone"];

                        identityScoreData.StreetLine1 = billingAddressObj == null ? string.Empty : (string)billingAddressObj["street_line_1"];
                        identityScoreData.StateCode = billingAddressObj == null ? string.Empty : (string)billingAddressObj["city"];
                        identityScoreData.City = billingAddressObj == null ? string.Empty : (string)billingAddressObj["state_code"];

                        identityScoreData.EmailAddress = (string)identityScoreRequestObj["email_address"];
                        identityScoreData.IPAddress = (string)identityScoreRequestObj["ip_address"];

                        // Extact components object
                        dynamic identityScoreComponentsObj = identityScoreObject.components;

                        // Checking null components object.
                        if (identityScoreComponentsObj != null)
                        {
                            List<Components> componentList = new List<Components>();
                            Components components = null;
                            foreach (var component in identityScoreObject.components)
                            {
                                components = new Components();

                                components.ScoreName = component == null ? string.Empty : (string)component["name"];
                                components.Score = component == null ? string.Empty : (string)component["score"];

                                componentList.Add(components);
                            }

                            identityScoreData.SetComponents(componentList.ToArray());
                        }

                        identityScoreDataList.Add(identityScoreData);
                    }
                }

            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
            }

            return identityScoreDataList;
        }
    }
}