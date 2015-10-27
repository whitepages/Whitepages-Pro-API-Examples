using Foundation;
using System;
using System.CodeDom.Compiler;
using UIKit;
using ProApiLibrary.Api.Clients;

namespace Phoneword_iOS
{
	public partial class SendGiftController : UIViewController
	{
		
		public SendGiftController (IntPtr handle) : base (handle)
		{
		}

		public override void ViewDidLoad ()
		{
			base.ViewDidLoad ();
			// Perform any additional setup after loading the view, typically from a nib.

			FindButton.TouchUpInside += (object sender, EventArgs e) => {

				ResultsViewController resultsScreen = this.Storyboard.InstantiateViewController("ResultsViewController") as ResultsViewController;
				if (resultsScreen != null) 
				{
					resultsScreen.WhereText = this.WhereText.Text;
					this.NavigationController.PushViewController(resultsScreen, true);
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
