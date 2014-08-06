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

namespace WhitePages
{
    public partial class phones_lookup : System.Web.UI.Page
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
        /// Button click event for find
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
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
                    Stream responseStream = webService.ExecuteWebRequest(nameValues, ref statusCode, ref description, ref errorMessage);

                    if (statusCode == 200 && responseStream != null)
                    {
                        StreamReader reader = new StreamReader(responseStream);
                        string responseInJson = reader.ReadToEnd();

                        dynamic jsonObject = JsonConvert.DeserializeObject(responseInJson);

                        // Dispose response stream
                        responseStream.Dispose();

                        dynamic dictionaryObj = jsonObject.dictionary;
                        string phoneKey = string.Empty;

                        foreach (var data in jsonObject.results)
                        {
                            phoneKey = data.Value;
                            break;
                        }

                        if (!string.IsNullOrEmpty(phoneKey))
                        {
                            dynamic phoneKeyObject = dictionaryObj[phoneKey];

                            string lineType = (string)phoneKeyObject["line_type"];
                            string phoneNumber = (string)phoneKeyObject["phone_number"];
                            string countryCallingCode = (string)phoneKeyObject["country_calling_code"];
                            string carrier = (string)phoneKeyObject["carrier"];
                            bool doNotCall = (bool)phoneKeyObject["do_not_call"];

                            dynamic spamScoreObj = phoneKeyObject.reputation;

                            string spamScore = (string)spamScoreObj["spam_score"];

                            phoneNumber = countryCallingCode + phoneNumber;
                            string formatedPhoneNumber = String.Format("{0:#-###-###-####}", Convert.ToInt64(phoneNumber));
                            formatedPhoneNumber = "+" + formatedPhoneNumber;

                            LitralPhoneNumber.Text = formatedPhoneNumber;
                            LiteralPhoneCarrier.Text = carrier;
                            LiteralPhoneType.Text = lineType;
                            if (doNotCall)
                            {
                                LiteralDndStatus.Text = "Registered";
                            }
                            else
                            {
                                LiteralDndStatus.Text = "Not Registered";
                            }

                            ResultDiv.Visible = true;

                            if (!string.IsNullOrEmpty(spamScore))
                            {
                                LiteralSpanScore.Text = spamScore + "%";
                            }
                            else
                            {
                                LiteralSpanScore.Text = "0%";
                            }

                            // Extracting location key from Phone details under best_location object.
                            dynamic bestLocationFromPhoneObj = phoneKeyObject.best_location;
                            dynamic bestLocationIdFromPhoneObj = bestLocationFromPhoneObj.id;
                            string locationKeyFromPhone = (string)bestLocationIdFromPhoneObj["key"];
                            

                            // Starting to extarct the person information
                            dynamic phoneKeyObjectBelongsToObj = phoneKeyObject.belongs_to;
                            dynamic belongsToObj = null;

                            List<string> personKeyListFromBelongsTo = new List<string>();
                            List<string> locationKeyList = new List<string>();

                            foreach (var data in phoneKeyObjectBelongsToObj)
                            {
                                belongsToObj = data.id;
                                string personKeyFromBelongsTo = (string)belongsToObj["key"];
                                personKeyListFromBelongsTo.Add(personKeyFromBelongsTo);
                            }

                            if (belongsToObj != null)
                            {
                                dynamic personKeyObject = null;
                                string peopleDetails = string.Empty;

                                foreach (string personKey in personKeyListFromBelongsTo)
                                {
                                    string peopleData = WhitePagesConstants.PeopleDataTemplates;

                                    personKeyObject = dictionaryObj[personKey];

                                    dynamic phoneKeyIdObj = personKeyObject.id;

                                    string personType = phoneKeyIdObj["type"];

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

                                    peopleData = peopleData.Replace(":PEOPLE_NAME", fullName);
                                    peopleData = peopleData.Replace(":TYPE", personType);

                                    peopleDetails += peopleData;



                                    // Collecting Locations Key
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

                                    if (string.IsNullOrEmpty(locationKey))
                                    {
                                        locationKey = locationKeyFromPhone;
                                    }

                                    locationKeyList.Add(locationKey);
                                }

                                LiteralPeopleDetails.Text = peopleDetails;

                                if (personKeyObject != null)
                                {
                                    string locationDetails = string.Empty;
                                    foreach (string locationKey in locationKeyList)
                                    {
                                        string locationDataTemplate = WhitePagesConstants.LocationDataTemplates;

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

                                        string receivingMail = isReceivingMail ? "Yes" : "No";

                                        locationDataTemplate = locationDataTemplate.Replace(":ADDRESS", fullAddress);
                                        locationDataTemplate = locationDataTemplate.Replace(":RECEIVING_MAIL", receivingMail);
                                        locationDataTemplate = locationDataTemplate.Replace(":USAGE", usage);
                                        locationDataTemplate = locationDataTemplate.Replace(":DELIVERY_POINT", deliveryPoint);

                                        locationDetails += locationDataTemplate;
                                    }

                                    LiteralLocationDetails.Text = locationDetails;
                                }
                            }
                        }
                    }
                    else
                    {
                        ResultDiv.Visible = false;
                        errorBox.Visible = true;
                        LiteralErrorMessage.Text = errorMessage;
                    }
                }
                else
                {
                    ResultDiv.Visible = false;
                    errorBox.Visible = true;
                    LiteralErrorMessage.Text = "please enter phone number";
                }
            }
            catch (Exception ex)
            {
                ResultDiv.Visible = false;
                errorBox.Visible = true;
                LiteralErrorMessage.Text = ex.Message;
            }
        }


    }
}