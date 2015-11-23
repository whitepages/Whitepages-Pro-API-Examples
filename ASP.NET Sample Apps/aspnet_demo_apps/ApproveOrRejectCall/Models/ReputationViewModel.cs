using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApproveOrRejectCall.Models
{
	public class ReputationViewModel
	{
		public string PhoneNumber { get; set; }
		public int? ReputationLevel { get; set; }

		public string ReputationDescription
		{
			get
			{
				switch (this.ReputationLevel)
				{
					case 1:
					{
						return "Low";
					}
					case 2:
					case 3:
					{
						return "Medium";
					}
					default:
					{
						return "High";
					}
				}
			}
		}

		public string Recommendation
		{
			get
			{
				switch(this.ReputationLevel)
				{
					case 1:
					{
						return "Approve";
					}
					case 2:
					case 3:
					{
						return "Review";
					}
					default:
					{
						return "Reject";
					}
				}
			}

		}

		public Exception Exception { get; set; }
	}
}
