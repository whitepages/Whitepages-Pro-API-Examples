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

namespace WhitePages
{
    public partial class personlookup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                errorDiv.Visible = false;
                personResult.Visible = false;
            }
        }

        /// <summary>
        /// FindButtonClick Event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ButtonFind_Click(object sender, EventArgs e)
        {
            try
            {
                errorDiv.Visible = false;
                LitralErrorMessage.Text = string.Empty;

                if ((string.IsNullOrEmpty(person_first_name.Text)))
                {
                    errorDiv.Visible = true;
                    LitralErrorMessage.Text = "please enter first name.";
                    return;
                }

                if (string.IsNullOrEmpty(person_last_name.Text))
                {
                    errorDiv.Visible = true;
                    LitralErrorMessage.Text = "last_name value must be at least 1 characters";
                    return;
                }

                if (string.IsNullOrEmpty(person_where.Text))
                {
                    errorDiv.Visible = true;
                    LitralErrorMessage.Text = "unparsed_location value must be at least 1 characters";
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
                Stream responseStream = webService.ExecuteWebRequest(nameValues, ref statusCode, ref description, ref errorMessage);

                if (statusCode == 200 && responseStream != null)
                {
                    StreamReader reader = new StreamReader(responseStream);
                    string responseInJson = reader.ReadToEnd();

                    // Dispose the response stream.
                    responseStream.Dispose();

                    dynamic jsonObject = JsonConvert.DeserializeObject(responseInJson);
                    dynamic dictionaryObj = jsonObject.dictionary;
                    List<string> personKeyList = new List<string>();

                    foreach (var data in jsonObject.results)
                    {
                        personKeyList.Add(data.Value);
                    }

                    string personData = string.Empty;

                    if (personKeyList.Count > 0)
                    {
                        foreach (string personKey in personKeyList)
                        {
                            string personDataTemplates = WhitePagesConstants.PersonDataTemplates;
                            string ageSection = WhitePagesConstants.ageSection;

                            dynamic personKeyObject = dictionaryObj[personKey];

                            dynamic ageRangeObject = personKeyObject["age_range"];

                            string personName = (string)personKeyObject["best_name"];

                            string ageRange = string.Empty;

                            if (ageRangeObject != null)
                            {
                                ageRange = (string)ageRangeObject["start"] + "+";
                            }

                            if (!string.IsNullOrEmpty(ageRange))
                            {
                                ageSection = ageSection.Replace(":AGE", ageRange);
                            }
                            else
                            {
                                ageSection = string.Empty;
                            }

                            dynamic bestLocationObject = personKeyObject["best_location"];
                            dynamic bestLocationIdObject = bestLocationObject["id"];
                            string bestLocationKey = (string)bestLocationIdObject["key"];

                            string contentType = string.Empty;

                            dynamic locationsObject = personKeyObject["locations"];
                            foreach (var location in locationsObject)
                            {
                                dynamic locationIdObject = location["id"];
                                string locationKey = (string)locationIdObject["key"];
                                
                                if (locationKey.ToUpper() == bestLocationKey.ToUpper())
                                {
                                    contentType = (string)location["contact_type"];
                                }
                            }

                            dynamic locationKeyObject = dictionaryObj[bestLocationKey];

                            string addressLine1 = (string)locationKeyObject["standard_address_line1"];
                            string addressLine2 = (string)locationKeyObject["standard_address_line2"];
                            string addressLocation = (string)locationKeyObject["standard_address_location"];

                            string usage = (string)locationKeyObject["usage"];
                            bool isReceivingMail = false;
                            if (locationKeyObject["is_receiving_mail"] != null)
                            {
                                isReceivingMail = (bool)locationKeyObject["is_receiving_mail"];
                            }
                            string deliveryPoint = (string)locationKeyObject["delivery_point"];

                            string fullAddress = string.Empty;
                            fullAddress += (string.IsNullOrEmpty(addressLine1) ? string.Empty : addressLine1 + "<br />");
                            fullAddress += (string.IsNullOrEmpty(addressLine2) ? string.Empty : addressLine2 + "<br />");
                            fullAddress += (string.IsNullOrEmpty(addressLocation) ? string.Empty : addressLocation + "<br />");

                            string receivingMail = isReceivingMail ? "Yes" : "No";


                            personDataTemplates = personDataTemplates.Replace(":FULL_NAME", personName);
                            personDataTemplates = personDataTemplates.Replace(":AGE", ageSection);
                            personDataTemplates = personDataTemplates.Replace(":FULL_ADDRESS", fullAddress);
                            personDataTemplates = personDataTemplates.Replace(":RECEIVING_MAIL", receivingMail);
                            personDataTemplates = personDataTemplates.Replace(":USAGE", usage);
                            personDataTemplates = personDataTemplates.Replace(":DELIVERY_POINT", deliveryPoint);
                            personDataTemplates = personDataTemplates.Replace(":TYPE", contentType);

                            personData += personDataTemplates;
                        }

                        personResult.Visible = true;

                        LiteralPersonResult.Text = personData;
                    }
                }
                else
                {
                    personResult.Visible = false;
                    errorDiv.Visible = true;
                    LitralErrorMessage.Text = errorMessage;
                }
            }
            catch (Exception ex)
            {
                errorDiv.Visible = true;
                LitralErrorMessage.Text = ex.Message;
            }
        }
    }
}