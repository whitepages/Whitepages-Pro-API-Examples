// ***********************************************************************
// Assembly         : WhitePagesPhoneLookup
// Author           : Kushal Shah
// Created          : 08-06-2014
//
// Last Modified By : Kushal Shah
// Last Modified On : 11-18-2014
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

                        // Calling ParsePhoneLookupResult to parse the response JSON in data Result class.
                        Result resultData = ParsePhoneLookupResult(responseInJson);

                        if (resultData != null)
                        {
                            // Calling function to populate data on UI.
                            PopulateDataOnUI(resultData);
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
        /// This method parse the Phone Lookup data to class Result.
        /// </summary>
        /// <param name="responseInJson">responseInJson</param>
        /// <returns>Result</returns>
        private Result ParsePhoneLookupResult(string responseInJson)
        {
            // Creating PhoneLookupData object to fill the phone lookup data.
            Result resultData = new Result();

            try
            {
                // responseInJson to DeserializeObject
                dynamic jsonObject = JsonConvert.DeserializeObject(responseInJson);

                if (jsonObject != null)
                {
                    // Take the dictionary object from jsonObject.
                    dynamic dictionaryObj = jsonObject.dictionary;

                    if (dictionaryObj != null)
                    {
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

                            if (phoneKeyObject != null)
                            {
                                // Creating phoneData object to fill the phone lookup data.
                                Phone phoneData = new Phone();

                                // Extracting lineType,phoneNumber, countryCallingCode, carrier, doNotCall status, spamScore from phoneKeyObject.
                                phoneData.PhoneType = (string)phoneKeyObject["line_type"];
                                phoneData.PhoneNumber = (string)phoneKeyObject["phone_number"];
                                phoneData.CountryCallingCode = (string)phoneKeyObject["country_calling_code"];
                                phoneData.Carrier = (string)phoneKeyObject["carrier"];
                                if (phoneKeyObject["do_not_call"] != null)
                                {
                                    phoneData.DndStatus = (bool)(phoneKeyObject["do_not_call"]);
                                }

                                dynamic spamScoreObj = phoneKeyObject.reputation;
                                if (spamScoreObj != null)
                                {
                                    phoneData.SpamScore = (string)spamScoreObj["spam_score"];
                                }

                                resultData.Phone = phoneData;

                                // Starting to extarct the person information.
                                dynamic phoneKeyObjectBelongsToObj = phoneKeyObject.belongs_to;

                                List<string> personKeyListFromBelongsTo = new List<string>();
                                List<string> locationKeyList = new List<string>();

                                if (phoneKeyObjectBelongsToObj != null)
                                {
                                    // Creating list of person key from phoneKeyObjectBelongsToObj.
                                    foreach (var data in phoneKeyObjectBelongsToObj)
                                    {
                                        dynamic belongsToObj = data.id;
                                        if (belongsToObj != null)
                                        {
                                            string personKeyFromBelongsTo = (string)belongsToObj["key"];

                                            if (!string.IsNullOrEmpty(personKeyFromBelongsTo))
                                            {
                                                personKeyListFromBelongsTo.Add(personKeyFromBelongsTo);
                                            }
                                        }
                                    }
                                }

                                List<People> peopleList = new List<People>();

                                if (personKeyListFromBelongsTo.Count > 0)
                                {
                                    People people = null;

                                    dynamic personKeyObject = null;

                                    foreach (string personKey in personKeyListFromBelongsTo)
                                    {
                                        people = new People();

                                        personKeyObject = dictionaryObj[personKey];

                                        if (personKeyObject != null)
                                        {
                                            // Get phoneKeyIdObj from personKeyObject.
                                            dynamic phoneKeyIdObj = personKeyObject.id;

                                            if (phoneKeyIdObj != null)
                                            {
                                                // Get person type from phoneKeyIdObj.
                                                people.PersonType = phoneKeyIdObj["type"];
                                            }

                                            // phoneKeyNamesObj from name node of personKeyObject.
                                            dynamic phoneKeyNamesObj = personKeyObject.names;

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

                                                people.PersonName = firstName + " " + lastName;
                                            }
                                            else
                                            {
                                                people.PersonName = personKeyObject.name;
                                            }

                                            // Collecting Locations Key. if best_location node exist other wise will take location key from locations node
                                            string locationKey = string.Empty;
                                            if (personKeyObject["best_location"] != null)
                                            {
                                                dynamic personBestLocationObj = personKeyObject.best_location;
                                                if (personBestLocationObj != null)
                                                {
                                                    dynamic bestLocationIdObj = personBestLocationObj.id;
                                                    if (bestLocationIdObj != null)
                                                    {
                                                        locationKey = (string)bestLocationIdObj["key"];
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                if (personKeyObject["locations"] != null)
                                                {
                                                    dynamic locationsPerPersonObj = personKeyObject.locations;
                                                    if (locationsPerPersonObj != null)
                                                    {
                                                        foreach (var personLocation in locationsPerPersonObj)
                                                        {
                                                            dynamic locationIdObj = personLocation.id;
                                                            if (locationIdObj != null)
                                                            {
                                                                locationKey = (string)locationIdObj["key"];
                                                                break;
                                                            }
                                                        }
                                                    }
                                                }
                                            }

                                            // If locationkey not found from best_location and locations node of personKeyObject 
                                            // than will take bestLocationFromPhoneObj.
                                            if (string.IsNullOrEmpty(locationKey))
                                            {
                                                // Extracting location key from Phone details under best_location object.
                                                dynamic bestLocationFromPhoneObj = phoneKeyObject.best_location;
                                                if (bestLocationFromPhoneObj != null)
                                                {
                                                    dynamic bestLocationIdFromPhoneObj = bestLocationFromPhoneObj.id;
                                                    if (bestLocationIdFromPhoneObj != null)
                                                    {
                                                        locationKey = (string)bestLocationIdFromPhoneObj["key"];
                                                    }
                                                }
                                            }

                                            locationKeyList.Add(locationKey);

                                            peopleList.Add(people);
                                        }
                                    }
                                    
                                    resultData.SetPeople(peopleList.ToArray());

                                    List<Location> locationList = new List<Location>();

                                    Location location = null;

                                    // Extracting all location for all locationKeyList from locationKeyObject.
                                    foreach (string locationKey in locationKeyList)
                                    {
                                        location = new Location();

                                        dynamic locationKeyObject = dictionaryObj[locationKey];

                                        if (locationKeyObject != null)
                                        {
                                            location.StandardAddressLine1 = (string)locationKeyObject["standard_address_line1"];
                                            location.StandardAddressLine2 = (string)locationKeyObject["standard_address_line2"];
                                            location.StandardAddressLocation = (string)locationKeyObject["standard_address_location"];
                                            if (locationKeyObject["is_receiving_mail"] != null)
                                            {
                                                location.ReceivingMail = (bool)(locationKeyObject["is_receiving_mail"]);
                                            }
                                            location.Usage = (string)locationKeyObject["usage"];
                                            location.DeliveryPoint = (string)locationKeyObject["delivery_point"];

                                            locationList.Add(location);
                                        }
                                    }

                                    resultData.SetLocation(locationList.ToArray());
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

            return resultData;
        }

        /// <summary>
        /// This method populates data on UI.
        /// </summary>
        /// <param name="resultData">resultData</param>
        private void PopulateDataOnUI(Result resultData)
        {
            // populating phone details on UI.

            bool dndStatus = resultData.Phone.DndStatus;

            string dndStatusText = string.Empty;

            if (dndStatus)
            {
                dndStatusText = WhitePagesConstants.RegisteredText;
            }
            else
            {
                dndStatusText = WhitePagesConstants.NotRegisteredText;
            }

            string spamScore = string.Empty;

            if (!string.IsNullOrEmpty(resultData.Phone.SpamScore))
            {
                spamScore = resultData.Phone.SpamScore + WhitePagesConstants.PercentText;
            }
            else
            {
                spamScore = WhitePagesConstants.ZeroPercentText;
            }

            // Concatenate country code and phone number.
            string phoneNumber = resultData.Phone.CountryCallingCode + resultData.Phone.PhoneNumber;

            // Formating phone number.
            string formatedPhoneNumber = String.Format(CultureInfo.CurrentCulture, "{0:#-###-###-####}", Convert.ToInt64(phoneNumber, CultureInfo.CurrentCulture));
            formatedPhoneNumber = "+" + formatedPhoneNumber;

            this.LitralPhoneNumber.Text = formatedPhoneNumber;
            this.LiteralPhoneCarrier.Text = resultData.Phone.Carrier;
            this.LiteralPhoneType.Text = resultData.Phone.PhoneType;
            this.LiteralDndStatus.Text = dndStatusText;
            this.LiteralSpamScore.Text = spamScore;
            
            this.ResultDiv.Visible = true;

            // Creating UI template for people and populate on UI.
            if (resultData.GetPeople() != null && resultData.GetPeople().Count() > 0)
            {
                string peopleDetails = string.Empty;

                foreach (People people in resultData.GetPeople())
                {
                    string peopleData = WhitePagesConstants.PeopleDataTemplates;

                    peopleData = peopleData.Replace(WhitePagesConstants.PeopleNameKey, people.PersonName);
                    peopleData = peopleData.Replace(WhitePagesConstants.TypeKey, people.PersonType);

                    peopleDetails += peopleData;
                }

                this.LiteralPeopleDetails.Text = peopleDetails;
            }

            // Creating UI template for location and populate on UI.
            if (resultData.GetLocation() != null && resultData.GetLocation().Count() > 0)
            {
                string locationDetails = string.Empty;
                foreach (Location location in resultData.GetLocation())
                {
                    string locationDataTemplate = WhitePagesConstants.LocationDataTemplates;

                    string receivingMail = location.ReceivingMail ? WhitePagesConstants.YesText : WhitePagesConstants.NoText;

                    string fullAddress = string.Empty;
                    fullAddress += string.IsNullOrEmpty(location.StandardAddressLine1) ? string.Empty : location.StandardAddressLine1 + "<br />";
                    fullAddress += string.IsNullOrEmpty(location.StandardAddressLine2) ? string.Empty : location.StandardAddressLine2 + "<br />";
                    fullAddress += string.IsNullOrEmpty(location.StandardAddressLocation) ? string.Empty : location.StandardAddressLocation;

                    locationDataTemplate = locationDataTemplate.Replace(WhitePagesConstants.AddressKey, fullAddress);
                    locationDataTemplate = locationDataTemplate.Replace(WhitePagesConstants.ReceivingMailKey, receivingMail);
                    locationDataTemplate = locationDataTemplate.Replace(WhitePagesConstants.UageEKey, location.Usage);
                    locationDataTemplate = locationDataTemplate.Replace(WhitePagesConstants.DeliveryPointKey, location.DeliveryPoint);

                    locationDetails += locationDataTemplate;
                }

                this.LiteralLocationDetails.Text = locationDetails;
            }
        }
    }
}