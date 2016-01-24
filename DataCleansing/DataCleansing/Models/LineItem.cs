using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataCleansing.Models
{
	public class LineItem
	{
		public virtual string FirstName { get; set; }
		public virtual string LastName { get; set; }
		public virtual string MiddleName { get; set; }
		public virtual string StreetAddress1 { get; set; }
		public virtual string StreetAddress2 { get; set; }
		public virtual string City { get; set; }
		public virtual string State { get; set; }
		public virtual string PostalCode { get; set; }

		public virtual string AsCsv()
		{
			const string FMT = "{0},{1},{2},{3},{4},{5},{6},{7}";
			var csv =
				string.Format(FMT, this.LastName, this.FirstName, this.MiddleName, this.StreetAddress1, this.StreetAddress2,
					this.City, this.State, this.PostalCode);
			return csv;
		}
	}
}
