using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;
using FindPerson.Models;
using ProApiLibrary.Api.Clients;
using ProApiLibrary.Api.Exceptions;
using ProApiLibrary.Api.Queries;
using ProApiLibrary.Api.Responses;
using ProApiLibrary.Data.Entities;

namespace FindPerson.Controllers
{
    public class HomeController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }

		[HttpPost]
	    public ActionResult Index(SearchModel model)
	    {
		    var searchResult = this.SearchProApi(model);
		    return View("~/Views/Home/Index.cshtml", searchResult);
	    }

		public Response<IPerson> SearchProApi(SearchModel model)
		{
			var apiKey = ConfigurationManager.AppSettings["api_key"];
			var client = new Client(apiKey);
			var query = new PersonQuery(model.FirstName, null, model.LastName, model.City, model.State, model.PostalCode);
			Response<IPerson> response;
			try
			{
				response = client.FindPeople(query);
			}
			catch (FindException)
			{
				throw new Exception(String.Format("FindPerson lookup for {0} {1} failed!", model.FirstName, model.LastName));
			}

			return response;


		}
    }
}