using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using ProApiLibrary.Api.Clients;
using ProApiLibrary.Api.Queries;

namespace LookupAndroid
{
	[Activity(Label = "Whitepages Pro API Results", Theme="@android:style/Theme.Holo.Light")]
	public class ResultActivity : Activity
	{
		protected override void OnCreate(Bundle bundle)
		{
			base.OnCreate(bundle);

			SetContentView(Resource.Layout.Result);

			TextView name = FindViewById<TextView>(Resource.Id.NameLabel);
			TextView where = FindViewById<TextView>(Resource.Id.WhereLabel);

			try
			{
				
				string phoneNumber = Intent.GetStringExtra("PhoneNumber") ?? "";
				if (string.IsNullOrWhiteSpace(phoneNumber))
				{
					base.Finish();
				}

				var apiKey = Resources.GetString(Resource.String.ApiKey);
				var client = new Client(apiKey);
				var phoneQuery = new PhoneQuery(phoneNumber);
				var response = client.FindPhones(phoneQuery);
				var phone = response.Results.FirstOrDefault();
				if (phone == null)
				{
					name.Text = response.ResponseMessages.First().Text;
				}
				else
				{
					name.Text = phone.PersonAssociations.FirstOrDefault().Person.BestName;
					where.Text = phone.BestLocation.City + " " + phone.BestLocation.PostalCode;
				}

				MainActivity.transitionToast.Cancel();

			}
			catch (Exception exc)
			{
				Toast.MakeText(this, exc.Message, ToastLength.Long).Show();
				name.Text = exc.Message;
			}

			Button button = FindViewById<Button>(Resource.Id.ConfirmButton);
			
			button.Click += delegate
			{
				Toast.MakeText(this, "You are now signed in.", ToastLength.Long).Show();
			};

		}
	}
}