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

namespace Whitepaper
{
    public partial class address_lookup : System.Web.UI.Page
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

                if ((string.IsNullOrEmpty(textBoxStreetLine1.Text) && string.IsNullOrEmpty(textBoxCity.Text)) || string.IsNullOrEmpty(textBoxStreetLine1.Text))
                {
                    errorBox.Visible = true;
                    LiteralErrorMessage.Text = "please enter your address details.";
                    return;
                }

                if (string.IsNullOrEmpty(textBoxCity.Text))
                {
                    errorBox.Visible = true;
                    LiteralErrorMessage.Text = "city value must be at least 1 characters";
                    return;
                }

                int statusCode = -1;
                string description = string.Empty;
                string errorMessage = string.Empty;

                NameValueCollection nameValues = new NameValueCollection();

                nameValues["street_line_1"] = textBoxStreetLine1.Text;
                nameValues["city"] = textBoxCity.Text;
                nameValues["api_key"] = WhitepapersConstants.ApiKey;

                WhitePapersWebService webService = new WhitePapersWebService();
                Stream responseStream = webService.ExecuteWebRequest(RequestApi.Address, nameValues, out statusCode, out description, out errorMessage);

                if (statusCode == 200 && responseStream != null)
                {
                    StreamReader reader = new StreamReader(responseStream);
                    string responseInJson = reader.ReadToEnd();

                    dynamic jsonObject = JsonConvert.DeserializeObject(responseInJson);
                    dynamic dictionaryObj = jsonObject.dictionary;
                    string locationKey = string.Empty;

                    foreach (var data in jsonObject.results)
                    {
                        locationKey = data.Value;
                        break;
                    }

                    if (!string.IsNullOrEmpty(locationKey))
                    {
                        dynamic locationKeyObject = dictionaryObj[locationKey];

                        string addressLine1 = (string)locationKeyObject["standard_address_line1"];
                        string addressLine2 = (string)locationKeyObject["standard_address_line2"];
                        string addressLocation = (string)locationKeyObject["standard_address_location"];

                        string usage = (string)locationKeyObject["usage"];
                        bool isReceivingMail = (bool)locationKeyObject["is_receiving_mail"];
                        string deliveryPoint = (string)locationKeyObject["delivery_point"];

                        string fullAddress = string.Empty;
                        fullAddress += (string.IsNullOrEmpty(addressLine1) ? string.Empty : addressLine1 + "<br />");
                        fullAddress += (string.IsNullOrEmpty(addressLine2) ? string.Empty : addressLine2 + "<br />");
                        fullAddress += (string.IsNullOrEmpty(addressLocation) ? string.Empty : addressLocation + "<br />");

                        LitralAddress.Text = fullAddress;
                        LiteralReceivingMail.Text = isReceivingMail ? "Yes" : "No";
                        LiteralUsage.Text = usage;
                        LiteralDeliveryPoint.Text = deliveryPoint;

                        ResultDiv.Visible = true;


                        dynamic locationLegalEntitiesObj = locationKeyObject.legal_entities_at;

                        if (locationLegalEntitiesObj != null)
                        {
                            List<string> personKeyList = new List<string>();
                            foreach (var locationLegalData in locationLegalEntitiesObj)
                            {
                                dynamic locationLegalDataAtId = locationLegalData.id;

                                string personKey = locationLegalDataAtId["key"];
                                personKeyList.Add(personKey);
                            }

                            LiteralPersonCount.Text = personKeyList.Count.ToString();

                            LiteralPersonDetails.Text = string.Empty;

                            if (personKeyList.Count > 0)
                            {
                                string personDetails = string.Empty;

                                foreach (string personKey in personKeyList)
                                {
                                    string personDataTemplates = WhitepapersConstants.PersonDataTemplates;

                                    dynamic personKeyObject = dictionaryObj[personKey];

                                    dynamic personIdObject = personKeyObject.id;

                                    string type = string.Empty;
                                    if (personIdObject != null)
                                    {
                                        type = (string)personIdObject["type"];
                                    }

                                    string fullName = (string)personKeyObject["best_name"];

                                    personDataTemplates = personDataTemplates.Replace(":PERSON_TYPE", type);
                                    personDataTemplates = personDataTemplates.Replace(":PERSON_NAME", fullName);

                                    personDetails += personDataTemplates;
                                }
                                LiteralPersonDetails.Text = personDetails;
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
            catch (Exception ex)
            {
                errorBox.Visible = true;
                LiteralErrorMessage.Text = ex.Message;
            }
        }
    }
}