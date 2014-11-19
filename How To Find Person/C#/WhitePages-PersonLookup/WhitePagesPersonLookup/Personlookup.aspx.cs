// ***********************************************************************
// Assembly         : WhitePagesPersonLookup
// Author           : Kushal Shah
// Created          : 08-06-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-18-2014
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

                    // Calling ParsePersonLookupResult to parse the response and return result data.
                    Result result = ParsePersonLookupResult(responseInJson);

                    if (result != null && result.GetPerson() != null && result.GetPerson().Length > 0)
                    {
                        // Calling function to populate data on UI.
                        PopulateDataOnUI(result);
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
        /// This method parse the Person Lookup data to class Result.
        /// </summary>
        /// <param name="responseInJson">responseInJson</param>
        /// <returns>Result</returns>
        private Result ParsePersonLookupResult(string responseInJson)
        {
            // Creating Result class to fill the person lookup data.
            Result result = new Result();

            try
            {
                // Creating list of Person class to fill the person lookup data.
                List<Person> personList = new List<Person>();

                // responseInJson to DeserializeObject
                dynamic jsonObject = JsonConvert.DeserializeObject(responseInJson);

                if (jsonObject != null)
                {
                    // Take the dictionary object from jsonObject.
                    dynamic dictionaryObj = jsonObject.dictionary;
                    if (dictionaryObj != null)
                    {
                        List<string> personKeyList = new List<string>();

                        // Creating list of all person key from result node of jsonObject.
                        foreach (var data in jsonObject.results)
                        {
                            personKeyList.Add(data.Value);
                        }

                        if (personKeyList.Count > 0)
                        {
                            Person personData = null;

                            foreach (string personKey in personKeyList)
                            {
                                personData = new Person();

                                // Extact person object for specific person key.
                                dynamic personKeyObject = dictionaryObj[personKey];
                                if (personKeyObject != null)
                                {
                                    // Extact person name from personKeyObject.
                                    personData.PersonName = (string)personKeyObject["best_name"];

                                    // Extact ageRangeObject from personKeyObject.
                                    dynamic ageRangeObject = personKeyObject["age_range"];

                                    if (ageRangeObject != null)
                                    {
                                        // Extact age range from ageRangeObject.
                                        personData.AgeRange = (string)ageRangeObject["start"];
                                    }

                                    // Extact bestLocationObject from personKeyObject.
                                    dynamic bestLocationObject = personKeyObject["best_location"];
                                    string bestLocationKey = string.Empty;
                                    if (bestLocationObject != null)
                                    {
                                        // Extact bestLocationIdObject from bestLocationObject.
                                        dynamic bestLocationIdObject = bestLocationObject["id"];

                                        if (bestLocationIdObject != null)
                                        {
                                            // Extact location key from bestLocationIdObject.
                                            bestLocationKey = (string)bestLocationIdObject["key"];
                                        }
                                    }

                                    if (!string.IsNullOrEmpty(bestLocationKey))
                                    {
                                        // Extact locationsObject from personKeyObject.
                                        dynamic locationsObject = personKeyObject["locations"];
                                        if (locationsObject != null)
                                        {
                                            foreach (var location in locationsObject)
                                            {
                                                dynamic locationIdObject = location["id"];

                                                if (locationIdObject != null)
                                                {
                                                    // Get location key from locationIdObject.
                                                    string locationKey = (string)locationIdObject["key"];

                                                    if (!string.IsNullOrEmpty(locationKey))
                                                    {
                                                        if (locationKey.ToUpper(CultureInfo.CurrentCulture) == bestLocationKey.ToUpper(CultureInfo.CurrentCulture))
                                                        {
                                                            personData.ContentType = (string)location["contact_type"];
                                                            break;
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        // Get locationKeyObject from dictionaryObj using bestLocationKey;
                                        dynamic locationKeyObject = dictionaryObj[bestLocationKey];

                                        if (locationKeyObject != null)
                                        {
                                            // Get address line1, line2 and location from locationKeyObject.
                                            personData.AddressLine1 = (string)locationKeyObject["standard_address_line1"];
                                            personData.AddressLine2 = (string)locationKeyObject["standard_address_line2"];
                                            personData.AddressLocation = (string)locationKeyObject["standard_address_location"];

                                            // Get usage from locationKeyObject.
                                            personData.Usage = (string)locationKeyObject["usage"];

                                            // Get isReceivingMail from locationKeyObject.
                                            personData.ReceivingMail = (bool)locationKeyObject["is_receiving_mail"];

                                            // Get deliveryPoint from locationKeyObject.
                                            personData.DeliveryPoint = (string)locationKeyObject["delivery_point"];
                                        }
                                    }

                                    // Adding person lookup data to personList.
                                    personList.Add(personData);
                                }
                            }

                            result.SetPerson(personList.ToArray());
                        }
                        else
                        {
                            this.personResult.Visible = false;
                            this.errorDiv.Visible = true;
                            LitralErrorMessage.Text = WhitePagesConstants.NoResultMessage;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                this.personResult.Visible = false;
                this.errorDiv.Visible = true;
                LitralErrorMessage.Text = ex.Message;
            }

            return result;
        }

        /// <summary>
        /// This method populates data on UI.
        /// </summary>
        /// <param name="result">result</param>
        private void PopulateDataOnUI(Result result)
        {
            string personDataFinalTemplate = string.Empty;

            // Creating template for person lookup and populate on UI.
            foreach (Person personData in result.GetPerson())
            {
                string personDataTemplates = WhitePagesConstants.PersonDataTemplates;

                // Converting ReceivingMail bool to string to show on UI.
                string receivingMail = personData.ReceivingMail ? WhitePagesConstants.YesText : WhitePagesConstants.NoText;

                // Creating Full Address.
                string fullAddress = string.Empty;
                fullAddress += (string.IsNullOrEmpty(personData.AddressLine1) ? string.Empty : personData.AddressLine1 + "<br />");
                fullAddress += (string.IsNullOrEmpty(personData.AddressLine2) ? string.Empty : personData.AddressLine2 + "<br />");
                fullAddress += (string.IsNullOrEmpty(personData.AddressLocation) ? string.Empty : personData.AddressLocation + "<br />");

                string ageSection = WhitePagesConstants.AgeSection;

                if (!string.IsNullOrEmpty(personData.AgeRange))
                {
                    ageSection = ageSection.Replace(WhitePagesConstants.AgeKey, personData.AgeRange);
                    ageSection = ageSection + WhitePagesConstants.PlusSign;
                }
                else
                {
                    ageSection = string.Empty;
                }

                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.FullNameKey, personData.PersonName);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.AgeKey, ageSection);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.FullAddressKey, fullAddress);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.ReceivingMailKey, receivingMail);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.UsageKey, personData.Usage);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.DeliveryPointKey, personData.DeliveryPoint);
                personDataTemplates = personDataTemplates.Replace(WhitePagesConstants.TypeKey, personData.ContentType);

                personDataFinalTemplate += personDataTemplates;
            }

            this.personResult.Visible = true;

            this.LiteralPersonResult.Text = personDataFinalTemplate;
        }
    }
}