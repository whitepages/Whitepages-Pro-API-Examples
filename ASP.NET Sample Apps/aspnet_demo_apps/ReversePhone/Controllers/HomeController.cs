using System;
using System.Configuration;
using System.Web.Mvc;
using ProApiLibrary.Api.Clients;
using ProApiLibrary.Api.Exceptions;
using ProApiLibrary.Api.Queries;
using ProApiLibrary.Api.Responses;
using ProApiLibrary.Data.Entities;

namespace ReversePhone.Controllers
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
			var response = this.SearchProApi(phoneNumber);
			return View(response);
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
	}
}