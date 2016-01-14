using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataCleansing.Models
{
	public class UploadedFile
	{
		/* the following numbers represent the column indices of the CSV */
		private const int LAST_NAME = 0;
		private const int FIRST_NAME = 1;
		private const int MIDDLE_NAME = 2;
		private const int STREET_ADDRESS_1 = 3;
		private const int STREET_ADDRESS_2 = 4;
		private const int CITY = 5;
		private const int STATE = 6;
		private const int POSTAL_CODE = 7;

		private List<LineItem> _lines;

		public virtual List<LineItem> Lines
		{
			get { return _lines ?? (_lines = new List<LineItem>()); }
			set { _lines = value; }
		}

		public virtual string OriginalFileName { get; set; }

		public static LineItem CreateItemFromLine(string line)
		{
			var elements = line.Split(',');
			return new LineItem()
			{
				LastName = elements[LAST_NAME],
				FirstName = elements[FIRST_NAME],
				MiddleName = elements[MIDDLE_NAME],
				StreetAddress1 = elements[STREET_ADDRESS_1],
				StreetAddress2 = elements[STREET_ADDRESS_2],
				City = elements[CITY],
				State = elements[STATE],
				PostalCode = elements[POSTAL_CODE]
			};
		}
	}
}
