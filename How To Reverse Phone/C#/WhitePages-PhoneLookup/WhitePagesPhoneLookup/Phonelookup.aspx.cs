// ***********************************************************************
// Assembly         : WhitePagesPhoneLookup
// Author           : Kushal Shah
// Created          : 08-06-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-06-2014
// ***********************************************************************
// <copyright file="Phonelookup.aspx.cs" company="Whitepages Pro">
//     . All rights reserved.
// </copyright>
// <summary>PhoneLookup class is code behind of Phonelookup page.</summary>
// ***********************************************************************

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
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

namespace WhitePagesPhoneLookup
{
    public partial class PhoneLookup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ResultDiv.Visible = false;
                errorBox.Visible = false;
                LiteralErrorMessage.Text = string.Empty;
            }
        }

        /// <summary>
        /// Event occurs when the Button control is clicked.
        /// Here we will call phone lookup API, parse result and populate result on UI
        /// </summary>
        /// <param name="sender">Object sender</param>
        /// <param name="e">event data.</param>
        protected void ButtonFindClick(object sender, EventArgs e)
        {
            try
            {
                errorBox.Visible = false;
                LiteralErrorMessage.Text = string.Empty;

                if (!string.IsNullOrEmpty(textBoxPhoneNumber.Text))
                {
                    int statusCode = -1;
                    string description = string.Empty;
                    string errorMessage = string.Empty;

                    NameValueCollection nameValues = new NameValueCollection();

                    nameValues["phone"] = textBoxPhoneNumber.Text;
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

                        // Calling ParsePhoneLookupResult to parse the response JSON in data class PhoneLookupData.
                        PhoneLookupData phoneLookupData = ParsePhoneLookupResult(responseInJson);

                        if (phoneLookupData != null)
                        {
                            // Calling function to populate data on UI.
                            PopulateDataOnUI(phoneLookupData);
                        }
                    }
                    else
                    {
                        this.ResultDiv.Visible = false;
                        this.errorBox.Visible = true;
                        this.LiteralErrorMessage.Text = errorMessage;
                    }
                }
                else
                {
                    this.ResultDiv.Visible = false;
                    this.errorBox.Visible = true;
                    this.LiteralErrorMessage.Text = WhitePagesConstants.PhoneBlankInputMessage;
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
        /// This method parse the Phone Lookup data to class PhoneLookupData.
        /// </summary>
        /// <param name="responseInJson">responseInJson</param>
        /// <returns>PhoneLookupData</returns>
        private PhoneLookupData ParsePhoneLookupResult(string responseInJson)
        {
            // Creating PhoneLookupData object to fill the phone lookup data.
            PhoneLookupData personLookupData = new PhoneLookupData();

            try
            {
                // responseInJson to DeserializeObject
                dynamic jsonObject = JsonConvert.DeserializeObject(responseInJson);

                // Take the dictionary object from jsonObject.
                dynamic dictionaryObj = jsonObject.dictionary;
                string phoneKey = string.Empty;

                // Take the phone key from result node of jsonObject
                foreach (var data in jsonObject.results)
                {
                    phoneKey = data.Value;
                    break;
                }

                // Checking phone key null or empty.
                if (!string.IsNullOrEmpty(phoneKey))
                {
                    // Get phone key object from dictionaryObj using phoneKey.
                    dynamic phoneKeyObject = dictionaryObj[phoneKey];

                    // Extracting lineType,phoneNumber, countryCallingCode, carrier, doNotCall status, spamScore from phoneKeyObject.
                    string lineType = (string)phoneKeyObject["line_type"];
                    string phoneNumber = (string)phoneKeyObject["phone_number"];
                    string countryCallingCode = (string)phoneKeyObject["country_calling_code"];
                    string carrier = (string)phoneKeyObject["carrier"];
                    bool doNotCall = (bool)phoneKeyObject["do_not_call"];

                    dynamic spamScoreObj = phoneKeyObject.reputation;

                    string spamScore = (string)spamScoreObj["spam_score"];

                    // Concatenate country code and phone number.
                    phoneNumber = countryCallingCode + phoneNumber;

                    // Formating phone number.
                    string formatedPhoneNumber = String.Format(CultureInfo.CurrentCulture, "{0:#-###-###-####}", Convert.ToInt64(phoneNumber, CultureInfo.CurrentCulture));
                    formatedPhoneNumber = "+" + formatedPhoneNumber;

                    personLookupData.PhoneNumber = formatedPhoneNumber;
                    personLookupData.Carrier = carrier;
                    personLookupData.PhoneType = lineType;
                    
                    if (doNotCall)
                    {
                        personLookupData.DndStatus = WhitePagesConstants.RegisteredText;
                    }
                    else
                    {
                        personLookupData.DndStatus = WhitePagesConstants.NotRegisteredText;
                    }

                    if (!string.IsNullOrEmpty(spamScore))
                    {
                        personLookupData.SpamScore = spamScore + WhitePagesConstants.PercentText;
                    }
                    else
                    {
                        personLookupData.SpamScore = WhitePagesConstants.ZeroPercentText;
                    }

                    // Extracting location key from Phone details under best_location object.
                    dynamic bestLocationFromPhoneObj = phoneKeyObject.best_location;
                    dynamic bestLocationIdFromPhoneObj = bestLocationFromPhoneObj.id;
                    string locationKeyFromPhone = (string)bestLocationIdFromPhoneObj["key"];

                    // Starting to extarct the person information.
                    dynamic phoneKeyObjectBelongsToObj = phoneKeyObject.belongs_to;

                    List<string> personKeyListFromBelongsTo = new List<string>();
                    List<string> locationKeyList = new List<string>();

                    // Creating list of person key from phoneKeyObjectBelongsToObj.
                    foreach (var data in phoneKeyObjectBelongsToObj)
                    {
                        dynamic belongsToObj = data.id;
                        string personKeyFromBelongsTo = (string)belongsToObj["key"];
                        personKeyListFromBelongsTo.Add(personKeyFromBelongsTo);
                    }

                    List<People> peopleList = new List<People>();

                    if (personKeyListFromBelongsTo != null && personKeyListFromBelongsTo.Count > 0)
                    {
                        People people = null;

                        dynamic personKeyObject = null;

                        foreach (string personKey in personKeyListFromBelongsTo)
                        {
                            people = new People();
                            
                            personKeyObject = dictionaryObj[personKey];

                            // Get phoneKeyIdObj from personKeyObject.
                            dynamic phoneKeyIdObj = personKeyObject.id;

                            // Get person type from phoneKeyIdObj.
                            string personType = phoneKeyIdObj["type"];

                            // phoneKeyNamesObj from name node of personKeyObject.
                            dynamic phoneKeyNamesObj = personKeyObject.names;

                            string fullName = string.Empty;

                            if (phoneKeyNamesObj != null)
                            {
                                string firstName = string.Empty;
                                string lastName = string.Empty;
                                string middleName = string.Empty;

                                foreach (var name in phoneKeyNamesObj)
                                {
                                    firstName = (string)name["first_name"];
                                    middleName = (string)name["middle_name"];
                                    lastName = (string)name["last_name"];
                                }

                                fullName = firstName + " " + lastName;
                            }
                            else
                            {
                                fullName = personKeyObject.name;
                            }

                            people.PersonName = fullName;
                            people.PersonType = personType;

                            // Collecting Locations Key. if best_location node exist other wise will take location key from locations node
                            string locationKey = string.Empty;
                            if (personKeyObject["best_location"] != null)
                            {
                                dynamic personBestLocationObj = personKeyObject.best_location;
                                dynamic bestLocationIdObj = personBestLocationObj.id;

                                locationKey = (string)bestLocationIdObj["key"];
                            }
                            else
                            {
                                if (personKeyObject["locations"] != null)
                                {
                                    dynamic locationsPerPersonObj = personKeyObject.locations;
                                    foreach (var location in locationsPerPersonObj)
                                    {
                                        dynamic locationIdObj = location.id;
                                        locationKey = (string)locationIdObj["key"];
                                        break;
                                    }
                                }
                            }

                            // If locationkey not found from best_location and locations node of personKeyObject 
                            // than will take locationKeyFromPhone.
                            if (string.IsNullOrEmpty(locationKey))
                            {
                                locationKey = locationKeyFromPhone;
                            }

                            locationKeyList.Add(locationKey);

                            peopleList.Add(people);
                        }

                        personLookupData.SetPeople(peopleList.ToArray());
                        
                        if (personKeyObject != null)
                        {
                            List<Location> locationList = new List<Location>();

                            Location location = null;

                            // Extracting all location for all locationKeyList from locationKeyObject.
                            foreach (string locationKey in locationKeyList)
                            {
                                location = new Location();

                                dynamic locationKeyObject = dictionaryObj[locationKey];

                                string standardAddressLine1 = (string)locationKeyObject["standard_address_line1"];
                                string standard_address_line2 = (string)locationKeyObject["standard_address_line2"];
                                string standard_address_location = (string)locationKeyObject["standard_address_location"];
                                bool isReceivingMail = false;
                                if (locationKeyObject["is_receiving_mail"] != null)
                                {
                                    isReceivingMail = (bool)locationKeyObject["is_receiving_mail"];
                                }
                                string usage = (string)locationKeyObject["usage"];
                                string deliveryPoint = (string)locationKeyObject["delivery_point"];

                                string fullAddress = string.Empty;
                                fullAddress += string.IsNullOrEmpty(standardAddressLine1) ? string.Empty : standardAddressLine1 + "<br />";
                                fullAddress += string.IsNullOrEmpty(standard_address_line2) ? string.Empty : standard_address_line2 + "<br />";
                                fullAddress += string.IsNullOrEmpty(standard_address_location) ? string.Empty : standard_address_location;

                                string receivingMail = isReceivingMail ? WhitePagesConstants.YesText : WhitePagesConstants.NoText;

                                location.Address = fullAddress;
                                location.ReceivingMail = receivingMail;
                                location.Usage = usage;
                                location.DeliveryPoint = deliveryPoint;

                                locationList.Add(location);
                            }

                            personLookupData.SetLocation(locationList.ToArray());
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

            return personLookupData;
        }

        /// <summary>
        /// This method populates data on UI.
        /// </summary>
        /// <param name="phoneLookupData">phoneLookupData</param>
        private void PopulateDataOnUI(PhoneLookupData phoneLookupData)
        {
            // populating phone details on UI.
            this.LitralPhoneNumber.Text = phoneLookupData.PhoneNumber;
            this.LiteralPhoneCarrier.Text = phoneLookupData.Carrier;
            this.LiteralPhoneType.Text = phoneLookupData.PhoneType;
            this.LiteralDndStatus.Text = phoneLookupData.DndStatus;
            this.LiteralSpamScore.Text = phoneLookupData.SpamScore;
            
            this.ResultDiv.Visible = true;

            // Creating UI template for people and populate on UI.
            if (phoneLookupData.GetPeople() != null && phoneLookupData.GetPeople().Count() > 0)
            {
                string peopleDetails = string.Empty;

                foreach (People people in phoneLookupData.GetPeople())
                {
                    string peopleData = WhitePagesConstants.PeopleDataTemplates;

                    peopleData = peopleData.Replace(WhitePagesConstants.PeopleNameKey, people.PersonName);
                    peopleData = peopleData.Replace(WhitePagesConstants.TypeKey, people.PersonType);

                    peopleDetails += peopleData;
                }

                this.LiteralPeopleDetails.Text = peopleDetails;
            }

            // Creating UI template for location and populate on UI.
            if (phoneLookupData.GetLocation() != null && phoneLookupData.GetLocation().Count() > 0)
            {
                string locationDetails = string.Empty;
                foreach (Location location in phoneLookupData.GetLocation())
                {
                    string locationDataTemplate = WhitePagesConstants.LocationDataTemplates;

                    locationDataTemplate = locationDataTemplate.Replace(WhitePagesConstants.AddressKey, location.Address);
                    locationDataTemplate = locationDataTemplate.Replace(WhitePagesConstants.ReceivingMailKey, location.ReceivingMail);
                    locationDataTemplate = locationDataTemplate.Replace(WhitePagesConstants.UageEKey, location.Usage);
                    locationDataTemplate = locationDataTemplate.Replace(WhitePagesConstants.DeliveryPointKey, location.DeliveryPoint);

                    locationDetails += locationDataTemplate;
                }

                this.LiteralLocationDetails.Text = locationDetails;
            }
        }
    }
}