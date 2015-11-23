// WARNING
//
// This file has been generated automatically by Xamarin Studio from the outlets and
// actions declared in your storyboard file.
// Manual changes to this file will not be maintained.
//
using Foundation;
using System;
using System.CodeDom.Compiler;
using UIKit;

namespace Phoneword_iOS
{
	[Register ("ResultsViewController")]
	partial class ResultsViewController
	{
		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UILabel AddressLabel { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UILabel CityLabel { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UIButton ConfirmButton { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UIButton GoBackButton { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UILabel NameLabel { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UILabel PhoneLabel { get; set; }

		void ReleaseDesignerOutlets ()
		{
			if (AddressLabel != null) {
				AddressLabel.Dispose ();
				AddressLabel = null;
			}
			if (CityLabel != null) {
				CityLabel.Dispose ();
				CityLabel = null;
			}
			if (ConfirmButton != null) {
				ConfirmButton.Dispose ();
				ConfirmButton = null;
			}
			if (GoBackButton != null) {
				GoBackButton.Dispose ();
				GoBackButton = null;
			}
			if (NameLabel != null) {
				NameLabel.Dispose ();
				NameLabel = null;
			}
			if (PhoneLabel != null) {
				PhoneLabel.Dispose ();
				PhoneLabel = null;
			}
		}
	}
}
