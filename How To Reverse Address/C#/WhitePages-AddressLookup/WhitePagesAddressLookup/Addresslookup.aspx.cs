// ***********************************************************************
// Assembly         : WhitePagesAddressLookup
// Author           : Kushal Shah
// Created          : 08-06-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-06-2014
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

                    // Calling ParseAddressLookupResult to parse the response JSON in data class AddressLookupData.
                    AddressLookupData addressLookupData = ParseAddressLookupResult(responseInJson);

                    if (addressLookupData != null)
                    {
                        // Calling function to populate data on UI.
                        PopulateDataOnUI(addressLookupData);
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
        /// This method parse the Address Lookup data to class AddressLookupData.
        /// </summary>
        /// <param name="responseInJson">responseInJson</param>
        /// <returns>List<AddressLookupData></returns>
        private AddressLookupData ParseAddressLookupResult(string responseInJson)
        {
            // Creating PersonLookupData object class to fill the address lookup data.
            AddressLookupData addressLookupData = new AddressLookupData();

            try
            {
                // responseInJson to DeserializeObject
                dynamic jsonObject = JsonConvert.DeserializeObject(responseInJson);

                // Take the dictionary object from jsonObject.
                dynamic dictionaryObj = jsonObject.dictionary;
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

                    // Get address line1, line2 and location from locationKeyObject.
                    string addressLine1 = (string)locationKeyObject["standard_address_line1"];
                    string addressLine2 = (string)locationKeyObject["standard_address_line2"];
                    string addressLocation = (string)locationKeyObject["standard_address_location"];

                    // Get usage from locationKeyObject.
                    string usage = (string)locationKeyObject["usage"];

                    // Get isReceivingMail from locationKeyObject.
                    bool isReceivingMail = (bool)locationKeyObject["is_receiving_mail"];

                    // Get deliveryPoint from locationKeyObject.
                    string deliveryPoint = (string)locationKeyObject["delivery_point"];

                    // Creating Full Address.
                    string fullAddress = string.Empty;
                    fullAddress += (string.IsNullOrEmpty(addressLine1) ? string.Empty : addressLine1 + "<br />");
                    fullAddress += (string.IsNullOrEmpty(addressLine2) ? string.Empty : addressLine2 + "<br />");
                    fullAddress += (string.IsNullOrEmpty(addressLocation) ? string.Empty : addressLocation + "<br />");

                    // Fill Address data to AddressLookupData class object.
                    addressLookupData.Address = fullAddress;
                    addressLookupData.ReceivingMail = isReceivingMail ? "Yes" : "No";
                    addressLookupData.Usage = usage;
                    addressLookupData.DeliveryPoint = deliveryPoint;
                    
                    // Now we will extrat all person for above location.
                    dynamic locationLegalEntitiesObj = locationKeyObject.legal_entities_at;

                    if (locationLegalEntitiesObj != null)
                    {
                        List<string> personKeyList = new List<string>();

                        // Extract all personKey from locationLegalEntitiesObj
                        foreach (var locationLegalData in locationLegalEntitiesObj)
                        {
                            dynamic locationLegalDataAtId = locationLegalData.id;

                            string personKey = locationLegalDataAtId["key"];
                            personKeyList.Add(personKey);
                        }

                        addressLookupData.NoOfPerson = personKeyList.Count;

                        List<Person> personList = new List<Person>();

                        Person person = null;

                        if (personKeyList.Count > 0)
                        {
                            string personDetails = string.Empty;

                            // Now we will search all person for each PersonKey.
                            foreach (string personKey in personKeyList)
                            {
                                person = new Person();

                                dynamic personKeyObject = dictionaryObj[personKey];

                                dynamic personIdObject = personKeyObject.id;

                                string type = string.Empty;
                                if (personIdObject != null)
                                {
                                    // Extract person type.
                                    type = (string)personIdObject["type"];
                                }

                                // Get person name.
                                string fullName = (string)personKeyObject["best_name"];

                                // Fill person class.
                                person.PersonName = fullName;
                                person.PersonType = type;

                                personList.Add(person);
                            }

                            addressLookupData.SetPerson(personList.ToArray());
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

            return addressLookupData;
        }

        /// <summary>
        /// This method populates data on UI.
        /// </summary>
        /// <param name="addressLookupData">addressLookupData</param>
        private void PopulateDataOnUI(AddressLookupData addressLookupData)
        {
		    // Populating address details on UI.
            this.LitralAddress.Text = addressLookupData.Address;
            this.LiteralReceivingMail.Text = addressLookupData.ReceivingMail;
            this.LiteralUsage.Text = addressLookupData.Usage;
            this.LiteralDeliveryPoint.Text = addressLookupData.DeliveryPoint;

            ResultDiv.Visible = true;
            
            if (addressLookupData.GetPerson() != null)
            {
                this.LiteralPersonCount.Text = addressLookupData.NoOfPerson.ToString(CultureInfo.CurrentCulture);

                this.LiteralPersonDetails.Text = string.Empty;
				
				// Creating address template and populate on UI.
                if (addressLookupData.GetPerson().Length > 0)
                {
                    string personDetails = string.Empty;
					
					// Populating person details.
                    foreach (Person person in addressLookupData.GetPerson())
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