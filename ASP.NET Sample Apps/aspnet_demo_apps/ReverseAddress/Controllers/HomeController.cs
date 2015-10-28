using System;
using System.Configuration;
using System.Web.Mvc;
using ProApiLibrary.Api.Clients;
using ProApiLibrary.Api.Exceptions;
using ProApiLibrary.Api.Queries;
using ProApiLibrary.Api.Responses;
using ProApiLibrary.Data.Entities;
using ReverseAddress.Models;

namespace ReverseAddress.Controllers
{
    public class HomeController : Controller
    {
        //
        // GET: /Home/
		[HttpGet]
        public ActionResult Index()
        {
            return View();
        }

		[HttpPost]
		public ActionResult Index(SearchModel model)
		{
			var response = this.SearchProApi(model.Address, model.City, model.State, model.PostalCode);
			return View("~/Views/Home/Index.cshtml", response);
		}

		public Response<ILocation> SearchProApi(string streetAddress, string city, string state, string postalCode)
		{
			Response<ILocation> response;

			var apiKey = ConfigurationManager.AppSettings["api_key"];
			var client = new Client(apiKey);
			var query = new LocationQuery(streetAddress, null, city, state, postalCode);
			try
			{
				response = client.FindLocations(query);
			}
			catch (FindException)
			{
				throw new Exception(String.Format("ReverseAddress lookup for {0} {1} {2} {3} failed!", streetAddress, city, state, postalCode));
			}

			return response;

		}
	}
}