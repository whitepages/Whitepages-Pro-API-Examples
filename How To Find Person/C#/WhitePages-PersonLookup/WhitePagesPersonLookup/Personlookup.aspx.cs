// ***********************************************************************
// Assembly         : WhitePagesPersonLookup
// Author           : Kushal Shah
// Created          : 08-06-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-06-2014
// ***********************************************************************
// <copyright file="Personlookup.aspx.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>PersonLookup class is code behind of Personlookup page.</summary>
// ***********************************************************************

using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Utilities;
using WebService;
using System.Globalization;

namespace WhitePagesPersonLookup
{
    public partial class PersonLookup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.errorDiv.Visible = false;
                this.personResult.Visible = false;
            }
        }

        /// <summary>
        /// Event occurs when the Button control is clicked.
        /// Here we will call person lookup API, parse result and populate result on UI
        /// </summary>
        /// <param name="sender">Object sender</param>
        /// <param name="e">event data.</param>
        protected void ButtonFindClick(object sender, EventArgs e)
        {
            try
            {
                this.errorDiv.Visible = false;
                this.LitralErrorMessage.Text = string.Empty;

                // Calling ValidateInput method to validate user's input.
                bool isInputValidated = ValidateInput();

                if (!isInputValidated)
                {
                    this.errorDiv.Visible = true;
                    return;
                }

                int statusCode = -1;
                string description = string.Empty;
                string errorMessage = string.Empty;

                NameValueCollection nameValues = new NameValueCollection();

                nameValues["first_name"] = person_first_name.Text;
                nameValues["last_name"] = person_last_name.Text;
                nameValues["address"] = person_where.Text;
                nameValues["api_key"] = WhitePagesConstants.ApiKey;

                WhitePagesWebService webService = new WhitePagesWebService();

                // Call method ExecuteWebRequest to execute backend API and return response stream.
                Stream responseStream = webService.ExecuteWebRequest(nameValues, ref statusCode, ref description, ref errorMessage);

                // Checking respnseStream null and status code.
                if (statusCode == 200 && responseStream != null)
                {
                    // Reading response stream to StreamReader.
                    StreamReader reader = new StreamReader(responseStream);

                    // Convert stream reader to string JSON.
                    string responseInJson = reader.ReadToEnd();

                    // Dispose the response stream.
                    responseStream.Dispose();

                    // Calling ParsePersonLookupResult to parse the response JSON in data class PersonLookupData.
                    List<PersonLookupData> personLookupDataList = ParsePersonLookupResult(responseInJson);

                    if (personLookupDataList != null && personLookupDataList.Count > 0)
                    {
                        // Calling function to populate data on UI.
                        PopulateDataOnUI(personLookupDataList);
                    }
                }
                else
                {
                    this.personResult.Visible = false;
                    this.errorDiv.Visible = true;
                    this.LitralErrorMessage.Text = errorMessage;
                }
            }
            catch (Exception ex)
            {
                this.errorDiv.Visible = true;
                this.LitralErrorMessage.Text = ex.Message;
            }
        }

        /// <summary>
        /// This method validates user's input.
        /// </summary>
        /// <returns>isInputValidated</returns>
        private bool ValidateInput()
        {
            bool isInputValidated = true;

            if ((string.IsNullOrEmpty(person_first_name.Text)) && isInputValidated == true)
            {
                this.errorDiv.Visible = true;
                this.LitralErrorMessage.Text = WhitePagesConstants.FirstNameBalnkInputMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(person_last_name.Text) && isInputValidated == true)
            {
                this.errorDiv.Visible = true;
                this.LitralErrorMessage.Text = WhitePagesConstants.LastNameBalnkInputMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(person_where.Text) && isInputValidated == true)
            {
                this.errorDiv.Visible = true;
                this.LitralErrorMessage.Text = WhitePagesConstants.LocationBalnkInputMessage;
                isInputValidated = false;
            }

            return isInputValidated;
        }

        /// <summary>
        /// This method parse the Person Lookup data to class PersonLookupData.
        /// </summary>
        /// <param name="responseInJson">responseInJson</param>
        /// <returns>List<PersonLookupData></returns>
        private List<PersonLookupData> ParsePersonLookupResult(string responseInJson)
        {
            // Creating list of PersonLookupData class to fill the person lookup data.
            List<PersonLookupData> personLookupDataList = new List<PersonLookupData>();

            try
            {
                // responseInJson to DeserializeObject
                dynamic jsonObject = JsonConvert.DeserializeObject(responseInJson);

                // Take the dictionary object from jsonObject.
                dynamic dictionaryObj = jsonObject.dictionary;

                List<string> personKeyList = new List<string>();

                // Creating list of all person key from result node of jsonObject.
                foreach (var data in jsonObject.results)
                {
                    personKeyList.Add(data.Value);
                }

                if (personKeyList.Count > 0)
                {
                    PersonLookupData personLookupData = null;

                    foreach (string personKey in personKeyList)
                    {
                        personLookupData = new PersonLookupData();

                        string ageSection = WhitePagesConstants.AgeSection;

                        // Extact person object for specific person key.
                        dynamic personKeyObject = dictionaryObj[personKey];

                        // Extact ageRangeObject from personObject.
                        dynamic ageRangeObject = personKeyObject["age_range"];

                        // Extact person name from personObject.
                        string personName = (string)personKeyObject["best_name"];

                        string ageRange = string.Empty;

                        if (ageRangeObject != null)
                        {
                            ageRange = (string)ageRangeObject["start"] + "+";
                        }

                        if (!string.IsNullOrEmpty(ageRange))
                        {
                            ageSection = ageSection.Replace(WhitePagesConstants.AgeKey, ageRange);
                        }
                        else
                        {
                            ageSection = string.Empty;
                        }

                        // Extact bestLocationObject from personObject.
                        dynamic bestLocationObject = personKeyObject["best_location"];

                        // Extact bestLocationIdObject from personObject.
                        dynamic bestLocationIdObject = bestLocationObject["id"];

                        // Extact location key from bestLocationIdObject.
                        string bestLocationKey = (string)bestLocationIdObject["key"];

                        string contentType = string.Empty;

                        // Extact locationsObject from personObject.
                        dynamic locationsObject = personKeyObject["locations"];
                        foreach (var location in locationsObject)
                        {
                            dynamic locationIdObject = location["id"];

                            // Get location key from locationIdObject.
                            string locationKey = (string)locationIdObject["key"];

                            if (locationKey.ToUpper(CultureInfo.CurrentCulture) == bestLocationKey.ToUpper(CultureInfo.CurrentCulture))
                            {
                                contentType = (string)location["contact_type"];
                                break;
                            }
                        }

                        // Get locationKeyObject from dictionaryObj using bestLocationKey;
                        dynamic locationKeyObject = dictionaryObj[bestLocationKey];

                        // Get address line1, line2 and location from locationKeyObject.
                        string addressLine1 = (string)locationKeyObject["standard_address_line1"];
                        string addressLine2 = (string)locationKeyObject["standard_address_line2"];
                        string addressLocation = (string)locationKeyObject["standard_address_location"];

                        // Get usage from locationKeyObject.
                        string usage = (string)locationKeyObject["usage"];
                        bool isReceivingMail = false;
                        if (locationKeyObject["is_receiving_mail"] != null)
                        {
                            // Get isReceivingMail from locationKeyObject.
                            isReceivingMail = (bool)locationKeyObject["is_receiving_mail"];
                        }

                        // Get deliveryPoint from locationKeyObject.
                        string deliveryPoint = (string)locationKeyObject["delivery_point"];

                        // Creating Full Address.
                        string fullAddress = string.Empty;
                        fullAddress += (string.IsNullOrEmpty(addressLine1) ? string.Empty : addressLine1 + "<br />");
                        fullAddress += (string.IsNullOrEmpty(addressLine2) ? string.Empty : addressLine2 + "<br />");
                        fullAddress += (string.IsNullOrEmpty(addressLocation) ? string.Empty : addressLocation + "<br />");

                        string receivingMail = isReceivingMail ? WhitePagesConstants.YesText : WhitePagesConstants.NoText;

                        personLookupData.AgeSection = ageSection;
                        personLookupData.ContentType = contentType;
                        personLookupData.Address = fullAddress;
                        personLookupData.PersonName = personName;
                        personLookupData.ReceivingMail = receivingMail;
                        personLookupData.Usage = usage;
                        personLookupData.DeliveryPoint = deliveryPoint;

                        // Adding person lookup data to personLookupDataList.
                        personLookupDataList.Add(personLookupData);
                    }
                }
                else
                {
                    this.personResult.Visible = false;
                    this.errorDiv.Visible = true;
                    LitralErrorMessage.Text = WhitePagesConstants.NoResultMessage;
                }
            }
            catch (Exception ex)
            {
                this.personResult.Visible = false;
                this.errorDiv.Visible = true;
                LitralErrorMessage.Text = ex.Message;
            }

            return personLookupDataList;
        }

        /// <summary>
        /// This method populates data on UI.
        /// </summary>
        /// <param name="personLookupDataList">personLookupDataList</param>
        private void PopulateDataOnUI(List<PersonLookupData> personLookupDataList)
        {
            string personData = string.Empty;

            // Creating template for person lookup and populate on UI.
            foreach (PersonLookupData personLookupData in personLookupDataList)
            {
                string personDataTemplates = WhitePagesConstants.PersonDataTemplates;

                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.FullNameKey, personLookupData.PersonName);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.AgeKey, personLookupData.AgeSection);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.FullAddressKey, personLookupData.Address);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.ReceivingMailKey, personLookupData.ReceivingMail);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.UsageKey, personLookupData.Usage);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.DeliveryPointKey, personLookupData.DeliveryPoint);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.TypeKey, personLookupData.ContentType);

                personData += personDataTemplates;
            }

            this.personResult.Visible = true;

            this.LiteralPersonResult.Text = personData;
        }
    }
}