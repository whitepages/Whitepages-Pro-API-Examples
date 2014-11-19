// ***********************************************************************
// Assembly         : WhitePagesAddressLookup
// Author           : Kushal Shah
// Created          : 08-06-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-18-2014
// ***********************************************************************
// <copyright file="Addresslookup.aspx.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>AddressLookup class is code behind of Addresslookup page.</summary>
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

namespace WhitePagesAddressLookup
{
    public partial class AddressLookup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.ResultDiv.Visible = false;
                this.errorBox.Visible = false;
                this.LiteralErrorMessage.Text = string.Empty;
            }
        }

        /// <summary>
        /// Event occurs when the Find Button control is clicked.
		/// Here we will call address lookup API, parse result and populate result on UI
        /// </summary>
        /// <param name="sender">Object sender</param>
        /// <param name="e">The event data.</param>
        protected void ButtonFindClick(object sender, EventArgs e)
        {
            try
            {
                this.errorBox.Visible = false;
                this.LiteralErrorMessage.Text = string.Empty;

                // Calling ValidateInput method to validate user's input.
                bool isInputValidated = ValidateInput();

                if (!isInputValidated)
                {
                    return;
                }

                int statusCode = -1;
                string description = string.Empty;
                string errorMessage = string.Empty;

                NameValueCollection nameValues = new NameValueCollection();

                nameValues["street_line_1"] = textBoxStreetLine1.Text;
                nameValues["city"] = textBoxCity.Text;
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

                    // Dispose response stream
                    responseStream.Dispose();

                    // Calling ParseAddressLookupResult to parse the response  to Result class.
                    Result addressResult = ParseAddressLookupResult(responseInJson);

                    if (addressResult != null && addressResult.Address != null)
                    {
                        // Calling function to populate data on UI.
                        PopulateDataOnUI(addressResult);
                    }
                }
                else
                {
                    this.ResultDiv.Visible = false;
                    this.errorBox.Visible = true;
                    this.LiteralErrorMessage.Text = errorMessage;
                }
            }
            catch (Exception ex)
            {
                this.ResultDiv.Visible = false;
                this.errorBox.Visible = true;
                this.LiteralErrorMessage.Text = ex.Message;
            }
        }

        /// <summary>
        /// This method validates user's input.
        /// </summary>
        /// <returns>isInputValidated</returns>
        private bool ValidateInput()
        {
            bool isInputValidated = true;
            
            if ((string.IsNullOrEmpty(textBoxStreetLine1.Text) && string.IsNullOrEmpty(textBoxCity.Text)) || string.IsNullOrEmpty(textBoxStreetLine1.Text))
            {
                this.errorBox.Visible = true;
                this.LiteralErrorMessage.Text = WhitePagesConstants.AddressBalnkInputMessage;
                isInputValidated = false;
            }

            if (string.IsNullOrEmpty(textBoxCity.Text))
            {
                this.errorBox.Visible = true;
                this.LiteralErrorMessage.Text = WhitePagesConstants.CityBalnkInputMessage;
                isInputValidated = false;
            }

            return isInputValidated;
        }

        /// <summary>
        /// This method parse the Address Lookup data to Result class.
        /// </summary>
        /// <param name="responseInJson">responseInJson</param>
        /// <returns>Result</returns>
        private Result ParseAddressLookupResult(string responseInJson)
        {
            // Creating Result class object to fill address lookup data.
            Result result = new Result();

            try
            {
                // Creating addressData object to fill the address details.
                Address addressData = new Address();

                // responseInJson to DeserializeObject
                dynamic jsonObject = JsonConvert.DeserializeObject(responseInJson);

                if (jsonObject != null)
                {
                    // Take the dictionary object from jsonObject.
                    dynamic dictionaryObj = jsonObject.dictionary;

                    if (dictionaryObj != null)
                    {
                        string locationKey = string.Empty;

                        // Get location key from jsonObject.results.
                        foreach (var data in jsonObject.results)
                        {
                            locationKey = data.Value;
                            break;
                        }

                        if (!string.IsNullOrEmpty(locationKey))
                        {
                            // Extact locationKeyObject for specific location key.
                            dynamic locationKeyObject = dictionaryObj[locationKey];

                            if (locationKeyObject != null)
                            {
                                // Get address line1, line2 and location from locationKeyObject.
                                // Fill Address data to Address class object.
                                addressData.AddressLine1 = (string)locationKeyObject["standard_address_line1"];
                                addressData.AddressLine2 = (string)locationKeyObject["standard_address_line2"];
                                addressData.AddressLocation = (string)locationKeyObject["standard_address_location"];

                                // Get usage from locationKeyObject.
                                addressData.Usage = (string)locationKeyObject["usage"];

                                if (locationKeyObject["is_receiving_mail"] != null)
                                {
                                    // Get isReceivingMail from locationKeyObject.
                                    addressData.ReceivingMail = (bool)(locationKeyObject["is_receiving_mail"]);
                                }

                                // Get deliveryPoint from locationKeyObject.
                                addressData.DeliveryPoint = (string)locationKeyObject["delivery_point"];

                                // Get location legel entities from locationKeyObject.
                                dynamic locationLegalEntitiesObj = locationKeyObject.legal_entities_at;

                                if (locationLegalEntitiesObj != null)
                                {
                                    List<string> personKeyList = new List<string>();

                                    // Extract all personKey from locationLegalEntitiesObj
                                    foreach (var locationLegalData in locationLegalEntitiesObj)
                                    {
                                        dynamic locationLegalDataAtId = locationLegalData.id;

                                        if (locationLegalDataAtId != null)
                                        {
                                            string personKey = locationLegalDataAtId["key"];
                                            if (!string.IsNullOrEmpty(personKey))
                                            {
                                                personKeyList.Add(personKey);
                                            }
                                        }
                                    }

                                    addressData.NoOfPerson = personKeyList.Count;

                                    result.Address = addressData;

                                    // Starting here to parse person data.
                                    List<Person> personList = new List<Person>();

                                    Person person = null;

                                    if (personKeyList.Count > 0)
                                    {
                                        // Now we will search all person for each PersonKey.
                                        foreach (string personKey in personKeyList)
                                        {
                                            person = new Person();
                                            dynamic personKeyObject = dictionaryObj[personKey];

                                            if (personKeyObject != null)
                                            {
                                                // Get person name.
                                                person.PersonName = (string)personKeyObject["best_name"];
                                                dynamic personIdObject = personKeyObject.id;

                                                if (personIdObject != null)
                                                {
                                                    // Extract person type.
                                                    person.PersonType = (string)personIdObject["type"];
                                                }
                                            }

                                            personList.Add(person);
                                        }

                                        result.SetPerson(personList.ToArray());
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                this.ResultDiv.Visible = false;
                this.errorBox.Visible = true;
                this.LiteralErrorMessage.Text = ex.Message;
            }

            return result;
        }

        /// <summary>
        /// This method populates data on UI.
        /// </summary>
        /// <param name="result">result</param>
        private void PopulateDataOnUI(Result result)
        {
		    // Populating address details on UI.

            // Creating Full Address.
            string fullAddress = string.Empty;
            fullAddress += (string.IsNullOrEmpty(result.Address.AddressLine1) ? string.Empty : result.Address.AddressLine1 + "<br />");
            fullAddress += (string.IsNullOrEmpty(result.Address.AddressLine2) ? string.Empty : result.Address.AddressLine2 + "<br />");
            fullAddress += (string.IsNullOrEmpty(result.Address.AddressLocation) ? string.Empty : result.Address.AddressLocation + "<br />");

            this.LitralAddress.Text = fullAddress;
            this.LiteralReceivingMail.Text = result.Address.ReceivingMail ? WhitePagesConstants.YesText : WhitePagesConstants.NoText;
            this.LiteralUsage.Text = result.Address.Usage;
            this.LiteralDeliveryPoint.Text = result.Address.DeliveryPoint;
            this.LiteralPersonCount.Text = result.Address.NoOfPerson.ToString(CultureInfo.CurrentCulture);

            ResultDiv.Visible = true;

            if (result.GetPerson() != null)
            {
                this.LiteralPersonDetails.Text = string.Empty;
				
				// Creating address template and populate on UI.
                if (result.GetPerson().Length > 0)
                {
                    string personDetails = string.Empty;
					
					// Populating person details.
                    foreach (Person person in result.GetPerson())
                    {
                        string personDataTemplates = WhitePagesConstants.PersonDataTemplates;

                        personDataTemplates = personDataTemplates.Replace(":PERSON_TYPE", person.PersonType);
                        personDataTemplates = personDataTemplates.Replace(":PERSON_NAME", person.PersonName);

                        personDetails += personDataTemplates;
                    }
                    this.LiteralPersonDetails.Text = personDetails;
                }
            }
        }
    }
}