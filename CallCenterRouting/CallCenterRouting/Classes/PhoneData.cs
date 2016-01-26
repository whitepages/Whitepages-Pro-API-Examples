using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ProApiLibrary.Data.Entities;

namespace CallCenter.Classes
{
	public class PhoneData : IComparable<PhoneData>
	{
		private List<string> _prioritizationNotes;
 
		public virtual string PhoneNumber { get; set; }
		public virtual DateTime CallTime { get; set; }

		public virtual List<string> PrioritizationNotes
		{
			get { return _prioritizationNotes ?? (_prioritizationNotes = new List<string>()); }
			set { _prioritizationNotes = value; }
		}

		public virtual LineType LineType { get; set; }
		public virtual bool DoNotCall { get; set; }
		public string Carrier { get; set; }

		public virtual bool IsCallBlocked
		{
			get { return this.ReputationLevel.HasValue && this.ReputationLevel.Value >= 3; }
		}
		public bool IsPrepaid { get; set; }

		public int? ReputationLevel { get; set; }

		public virtual int SortOrder
		{
			get
			{
				if (this.IsCallBlocked)
				{
					return 8; // lowest possible sort order
				}
				else if (this.LineType == LineType.Mobile)
				{
					return 1; // highest possible sort order
				}
				else if ((this.LineType == LineType.LandLine)
				         && this.DoNotCall)
				{
					return 2;
				}
				else if ((this.LineType == LineType.LandLine)
				         || (this.LineType == LineType.FixedVoip))
				{
					return 3;
				}
				else if (this.IsPrepaid)
				{
					return 4;
				}
				else if (this.LineType == LineType.NonFixedVoip)
				{
					return 5;
				}
				else if ((this.LineType == LineType.TollFree)
				         || (this.LineType == LineType.Premium))
				{
					return 6;
				}
				else
				{
					return 7;
				}
				
			}
		}
		public int CompareTo(PhoneData other)
		{
			if (other == null)
			{
				return 1;
			}

			return this.SortOrder.CompareTo(other.SortOrder);
		}
	}
}
