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
    public partial class identity_score : System.Web.UI.Page
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
        /// <param name="sender">sender</param>
        /// <param name="e">EventArgs</param>
        protected void ButtonFind_Click(object sender, EventArgs e)
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
                    PopulateDataOnUi(identityScoreDataList);
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

                identityScoreResult.Visible = false;
                errorDiv.Visible = true;
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
                errorDiv.Visible = true;
                LitralErrorMessage.Text = WhitePagesConstants.NameNotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(billing_address_street_line_1.Text) && isInputValidated == true)
            {
                errorDiv.Visible = true;
                LitralErrorMessage.Text = WhitePagesConstants.BillingAddressStreetLine1NotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(billing_address_city.Text) && isInputValidated == true)
            {
                errorDiv.Visible = true;
                LitralErrorMessage.Text = WhitePagesConstants.BillingAddressCityNotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(billing_address_state_code.Text) && isInputValidated == true)
            {
                errorDiv.Visible = true;
                LitralErrorMessage.Text = WhitePagesConstants.BillingAddressStateCodeNotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(billing_phone.Text) && isInputValidated == true)
            {
                errorDiv.Visible = true;
                LitralErrorMessage.Text = WhitePagesConstants.BillingPhoneNotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(ip_address.Text) && isInputValidated == true)
            {
                errorDiv.Visible = true;
                LitralErrorMessage.Text = WhitePagesConstants.IpAddressNotProvidedMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(email_address.Text) && isInputValidated == true)
            {
                errorDiv.Visible = true;
                LitralErrorMessage.Text = WhitePagesConstants.EmailAddressNotProvidedMessage;
                isInputValidated = false;
            }

            return isInputValidated;
        }

        /// <summary>
        /// This method populates data on UI.
        /// </summary>
        /// <param name="identityScoreDataList">identityScoreDataList</param>
        private void PopulateDataOnUi(List<IdentityScoreData> identityScoreDataList)
        {
            string identityScoreDataTemplates = WhitePagesConstants.IdentityScoreDataTemplates;

            string identityScoreDataString = string.Empty;

            foreach(IdentityScoreData identityScoreData in identityScoreDataList)
            {
                string componentDataString = string.Empty;
                string identityScoreDataBox = WhitePagesConstants.IdentityScoreDataBox;

                foreach(Components component in identityScoreData.components)
                {
                    identityScoreDataTemplates = WhitePagesConstants.IdentityScoreDataTemplates;

                    identityScoreDataTemplates = identityScoreDataTemplates.Replace(":SCORE_NAME", component.scoreName);
                    identityScoreDataTemplates = identityScoreDataTemplates.Replace(":SCORE", string.IsNullOrEmpty(component.score) ? WhitePagesConstants.NaText : component.score);

                    componentDataString += identityScoreDataTemplates;
                }

                identityScoreDataString += identityScoreDataBox.Replace(":IDENTITY_SCORE_RESULT", componentDataString);
            }

            identityScoreResult.Visible = true;

            LiteralIdentityScoreResult.Text = identityScoreDataString;
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

                        identityScoreData.billingName = billingNameObj == null ? string.Empty : (string)billingNameObj["name"];
                        identityScoreData.shippingName = shippingNameObj == null ? string.Empty : (string)shippingNameObj["name"];
                        identityScoreData.billingPhone = (string)identityScoreRequestObj["billing_phone"];

                        identityScoreData.streetLine1 = billingAddressObj == null ? string.Empty : (string)billingAddressObj["street_line_1"];
                        identityScoreData.stateCode = billingAddressObj == null ? string.Empty : (string)billingAddressObj["city"];
                        identityScoreData.city = billingAddressObj == null ? string.Empty : (string)billingAddressObj["state_code"];

                        identityScoreData.emailAddress = (string)identityScoreRequestObj["email_address"];
                        identityScoreData.ipAddress = (string)identityScoreRequestObj["ip_address"];

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

                                components.scoreName = component == null ? string.Empty : (string)component["name"];
                                components.score = component == null ? string.Empty : (string)component["score"];

                                componentList.Add(components);
                            }

                            identityScoreData.components = componentList.ToArray();
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