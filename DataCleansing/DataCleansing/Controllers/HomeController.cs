using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using DataCleansing.Models;
using ProApiLibrary.Api.Clients;
using ProApiLibrary.Api.Exceptions;
using ProApiLibrary.Api.Queries;
using ProApiLibrary.Api.Responses;
using ProApiLibrary.Data.Entities;

namespace DataCleansing.Controllers
{
    public class HomeController : Controller
    {
		[HttpGet]
        public ActionResult Index()
        {
            return View();
        }

	    [HttpPost]
	    public ActionResult Upload()
	    {
		    Session["Complete"] = false;
		    UploadedFile file = null;
		    foreach (string fileName in Request.Files)
		    {
			    var hpf = Request.Files[fileName];
			    if (hpf != null)
			    {
					using (var s = hpf.InputStream)
					{
						file = this.ConvertPostedFile(s, fileName);
						s.Close();
					}	    
			    }
		    }

		    if (file == null)
		    {
			    throw new Exception("Unable to obtain the uploaded file data.");
		    }

			// now I have a representation of the file. Run it through the API
		    foreach (var lineItem in file.Lines)
		    {
			    this.PopulateFromApi(lineItem);
		    }
			// now I should have a file that includes the address info
			// get the file contents as a string
		    var contents = GetFileAsCsv(file);

		    var encoding = Encoding.UTF8;
			var bytes = encoding.GetBytes(contents);
		    Session["Complete"] = true;
		    return File(bytes, "text/csv", "cleansed.csv");
		}

	    public virtual UploadedFile ConvertPostedFile(Stream inputStream, string originalFileName)
	    {
			if (inputStream == null)
			{
				throw new Exception("Null stream.");
			}

			if (!inputStream.CanRead)
			{
				throw new Exception("Can't read stream.");
			}

		    var file = new UploadedFile()
		    {
			    OriginalFileName = originalFileName,
		    };

			using (var sr = new StreamReader(inputStream))
		    {
			    string line;
			    while ((line = sr.ReadLine()) != null)
			    {
				    var lineItem = UploadedFile.CreateItemFromLine(line);
				    file.Lines.Add(lineItem);
			    }
		    }

		    return file;
	    }

	    public virtual void PopulateFromApi(LineItem model)
	    {
		    string add1 = null;
		    string add2 = null;
		    string city = null;
		    string state = null;
		    string postalCode = null;

		    var response = this.SearchProApi(model);
		    if ((response != null) && (!response.IsFailure))
		    {
			    var bestMatch = response.Results.FirstOrDefault();
			    if (bestMatch != null)
			    {
				    var bestLocation = bestMatch.BestLocation;
				    if (bestLocation != null)
				    {
					    add1 = bestLocation.StandardAddressLine1;
					    add2 = bestLocation.StandardAddressLine2;
					    city = bestLocation.City;
					    state = bestLocation.StateCode;
					    postalCode = bestLocation.PostalCode;
				    }
			    }
		    }

		    model.StreetAddress1 = add1;
		    model.StreetAddress2 = add2;
		    model.City = city;
		    model.State = state;
		    model.PostalCode = postalCode;
	    }

		public Response<IPerson> SearchProApi(LineItem model)
		{
			var apiKey = ConfigurationManager.AppSettings["api_key"];
			var client = new Client(apiKey);
			var query = new PersonQuery(model.FirstName, null, model.LastName, model.City, model.State, model.PostalCode);
			query.UseHistorical = true;
			query.StreetLine1 = model.StreetAddress1;
			query.StreetLine2 = model.StreetAddress2;
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

	    public virtual string GetFileAsCsv(UploadedFile file)
	    {
		    var sb = new StringBuilder();
		    foreach (var lineItem in file.Lines)
		    {
			    sb.AppendLine(lineItem.AsCsv());
		    }
		    return sb.ToString();
	    }

	    public ContentResult SimpleStatePoll()
	    {
		    if (Session["Complete"] == null)
		    {
				return new JsonStringResult(@"{""complete"":""unknown""}");
		    }
		    var state = (bool) Session["Complete"];
		    if (state)
		    {
			    return new JsonStringResult(@"{""complete"":""true""}");
		    }
		    else
		    {
				return new JsonStringResult(@"{""complete"":""false""}");
		    }
	    }

    }

	public class JsonStringResult : ContentResult
	{
		public JsonStringResult(string json)
		{
			Content = json;
			ContentType = "application/json";
		}
	}
}