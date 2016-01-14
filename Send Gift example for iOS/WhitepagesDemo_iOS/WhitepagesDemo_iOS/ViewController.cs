using System;
using Foundation;
using ProApiLibrary.Api.Clients;

using UIKit;

namespace Phoneword_iOS
{
	public partial class ViewController : UIViewController
	{
		public ViewController (IntPtr handle) : base (handle)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();
			// Perform any additional setup after loading the view, typically from a nib.

			ProApiButton.TouchUpInside += (object sender, EventArgs e) => {
				
				SendGiftController giftScreen = this.Storyboard.InstantiateViewController("SendGiftController") as SendGiftController;
				if (giftScreen != null) 
				{
					this.NavigationController.PushViewController(giftScreen, true);
				}
			};
		}

		public override void DidReceiveMemoryWarning ()
		{
			base.DidReceiveMemoryWarning ();
			// Release any cached data, images, etc that aren't in use.
		}
	}
}

