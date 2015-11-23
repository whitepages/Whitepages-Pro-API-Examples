using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CallCenter.Classes;
using ProApiLibrary.Api.Clients;
using ProApiLibrary.Api.Exceptions;
using ProApiLibrary.Api.Queries;
using ProApiLibrary.Api.Responses;
using ProApiLibrary.Data.Entities;

namespace CallCenter.Controllers
{
    public class HomeController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            return View(new List<PhoneData>());
        }

	    [HttpPost]
	    public ActionResult Index(string phoneNumber)
	    {
		    var callList = Session["Calls"] as List<PhoneData>;
		    if (callList == null)
		    {
			    callList = new List<PhoneData>();
		    }
		    var call = this.ConstructPhoneData(phoneNumber);
		    callList.Add(call);
		    return View(callList);
	    }

	    protected internal virtual PhoneData ConstructPhoneData(string phoneNumber)
	    {
		    var response = this.SearchProApi(phoneNumber);
		    var notes = new List<string>();
		    var lineType = LineType.Other;
		    var doNotCall = false;
			string carrier = null;
		    int? reputationLevel = null;
		    var isPrepaid = false;

		    if (!response.IsFailure)
		    {
			    var phone = response.Results.FirstOrDefault();
			    if (phone != null)
			    {
				    lineType = phone.LineType.GetValueOrDefault(LineType.Other);
				    doNotCall = phone.DoNotCall.GetValueOrDefault(false);
				    carrier = phone.Carrier;
				    reputationLevel = phone.Reputation == null ? (int?) null : phone.Reputation.Level;
				    isPrepaid = phone.IsPrepaid ?? false;
			    }
		    }

		    if (lineType != LineType.Other)
		    {
			    notes.Add(lineType.ToString());
		    }
		    if (doNotCall)
		    {
			    notes.Add("Do Not Call Registered");
		    }
		    if (!string.IsNullOrWhiteSpace(carrier))
		    {
			    notes.Add(carrier);
		    }
			var call = new PhoneData()
			{
				CallTime = DateTime.Now,
				PhoneNumber = phoneNumber,
				PrioritizationNotes = notes,
				LineType = lineType,
				DoNotCall = doNotCall,
				Carrier = carrier,
				ReputationLevel = reputationLevel,
				IsPrepaid = isPrepaid,
			};

		    return call;
	    }

	    protected internal virtual Response<IPhone> SearchProApi(string phoneNumber)
	    {
		    Response<IPhone> response;

		    var apiKey = ConfigurationManager.AppSettings["api_key"];
		    var client = new Client(apiKey);
		    var query = new PhoneQuery(phoneNumber);
		    try
		    {
			    response = client.FindPhones(query);
		    }
		    catch (FindException)
		    {
			    throw new Exception(string.Format("ReversePhone lookup for {0} failed!", phoneNumber));
		    }

		    return response;
	    }
    }
}