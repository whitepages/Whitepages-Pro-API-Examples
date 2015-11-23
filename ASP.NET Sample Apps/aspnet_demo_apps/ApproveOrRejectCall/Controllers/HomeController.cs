using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ApproveOrRejectCall.Models;
using ProApiLibrary.Api.Clients;
using ProApiLibrary.Api.Exceptions;
using ProApiLibrary.Api.Queries;
using ProApiLibrary.Api.Responses;
using ProApiLibrary.Data.Entities;

namespace ApproveOrRejectCall.Controllers
{
    public class HomeController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }

	    [HttpPost]
	    public ActionResult Index(string phoneNumber)
	    {
		    var model = this.GetModel(phoneNumber);
		    return View(model);
	    }

	    public ReputationViewModel GetModel(string phoneNumber)
	    {
		    try
		    {
			    var response = this.SearchProApi(phoneNumber);
			    if (response == null)
			    {
				    throw new Exception("Null response from the API.");
			    }
				else if (response.IsFailure)
				{
					// try to get reputation level anyway
					return new ReputationViewModel()
					{
						Exception = new Exception("Response failure! " + response.ResponseMessages.FirstOrDefault().Text),
						PhoneNumber = phoneNumber,
						ReputationLevel = this.ExtractReputationLevelFromResponse(response),
					};
				}

			    var phone = response.Results.FirstOrDefault();
			    if (phone == null)
			    {
				    throw new Exception("Zero results were returned.");
			    }
			    var reputation = phone.Reputation;
			    if (reputation == null)
			    {
					throw new Exception("No reputation information was returned!");
			    }
				var level = reputation.Level;
			    if (level == null)
			    {
				    throw new Exception("No reputation level was returned.");
			    }
			    return new ReputationViewModel
			    {
				    PhoneNumber = phoneNumber,
				    ReputationLevel = level.Value,
			    };
		    }
		    catch (Exception exc)
		    {
			    return new ReputationViewModel
			    {
				    PhoneNumber = phoneNumber,
				    Exception = exc
			    };
		    }
	    }

		public Response<IPhone> SearchProApi(string phoneNumber)
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

	    protected internal virtual int? ExtractReputationLevelFromResponse(Response<IPhone> response)
	    {
		    int? level = null;
		    if (response != null)
		    {
			    var first = response.Results.FirstOrDefault();
			    if (first != null)
			    {
				    var reputation = first.Reputation;
				    if (reputation != null)
				    {
					    level = reputation.Level;
				    }
			    }
		    }
		    return level;
	    }
    }
}