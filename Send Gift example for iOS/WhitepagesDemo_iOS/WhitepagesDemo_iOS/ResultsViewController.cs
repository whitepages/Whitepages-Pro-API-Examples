using Foundation;
using System;
using System.CodeDom.Compiler;
using UIKit;
using ProApiLibrary.Api.Clients;

namespace Phoneword_iOS
{
	public partial class ResultsViewController : UIViewController
	{
		public string WhereText = "";

		public ResultsViewController (IntPtr handle) : base (handle)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();
			// Perform any additional setup after loading the view, typically from a nib.

			ConfirmButton.TouchUpInside += (object sender, EventArgs e) => {

				var alert = this.CreateSimpleAlert("Success!", "Your gift recipient was successfully identified.");
				PresentViewController(alert, true, null);
			};

			GoBackButton.TouchUpInside += (object sender, EventArgs e) => {

				NavigationController.PopViewController(true);
			};


			if (!String.IsNullOrWhiteSpace(WhereText)) {
				var apiKey = "<YOUR API KEY HERE>";
				var client = new Client(apiKey);
				var commaParts = WhereText.Split(new [] {','});
				var name = commaParts[0];
				var cityState = commaParts[1];
				var whereParts = cityState.Split(new [] {' '});
				var city = whereParts[0];
				var state = whereParts[1];

				var query = new ProApiLibrary.Api.Queries.PersonQuery(name, city, state, null);
				var response = client.FindPeople(query);
				var results = response.Results;
				var resultCount = (results == null) ? 0 : results.Count;
				if (resultCount <= 0)
				{
					var alert = CreateSimpleAlert ("No results", "No results were returned from the WhitePages Pro API");
					PresentViewController (alert, true, null);
				} 
				else
				{
					var best = results [0];
					var bestName = best.BestName;
					this.NameLabel.Text = bestName;

					var location = best.BestLocation;
					if (location != null)
					{
						this.AddressLabel.Text = location.StandardAddressLine1;
						this.CityLabel.Text = location.City + " " + location.PostalCode;
					}

					if (best.PhoneAssociations.Count > 0)
					{
						var bestPhone = best.PhoneAssociations [0];
						if (bestPhone != null)
						{
							this.PhoneLabel.Text = bestPhone.Phone.PhoneNumber;
						}
					}
				}
			} else {
				this.NavigationController.PopViewController(true);
			}

		}

		protected UIViewController CreateSimpleAlert (string title, string message)
		{
			var alert = UIAlertController.Create(title, message, UIAlertControllerStyle.Alert);
			alert.AddAction(UIAlertAction.Create("OK", UIAlertActionStyle.Default, null));
			return alert;

		}

		public override void DidReceiveMemoryWarning ()
		{
			base.DidReceiveMemoryWarning ();
			// Release any cached data, images, etc that aren't in use.
		}
	}
}
