using System;
using Android.App;
using Android.Content;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Android.OS;

namespace LookupAndroid
{
	[Activity(Label = "Whitepages Lookup", MainLauncher = true, Icon = "@drawable/icon", Theme="@android:style/Theme.Holo.Light")]
	public class MainActivity : Activity
	{
		int count = 1;
		public static Toast transitionToast;

		protected override void OnCreate(Bundle bundle)
		{
			base.OnCreate(bundle);

			// Set our view from the "main" layout resource
			SetContentView(Resource.Layout.Main);

			// Get our button from the layout resource,
			// and attach an event to it
			Button button = FindViewById<Button>(Resource.Id.MyButton);
			EditText phoneEditText = FindViewById<EditText>(Resource.Id.PhoneNumberText);
			
			button.Click += delegate
			{
				var phoneNumber = phoneEditText.Text;
				var activity = new Intent(this, typeof(ResultActivity));
				activity.PutExtra("PhoneNumber", phoneNumber);

				transitionToast = Toast.MakeText(this, "Loading...", ToastLength.Long);
				transitionToast.Show();
				StartActivity(activity);
			};
		}
	}
}

