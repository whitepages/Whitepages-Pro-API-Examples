using System;
using ProApiLibrary.Data.Associations;
using ProApiLibrary.Data.Entities;

namespace ReversePhone.Classes
{
	public static class Display
	{
		public static string NullableBoolean(bool? value)
		{
			return value.HasValue ? value.Value.ToString() : "Unknown";
		}

		public static string AgeRange(AgeRange value)
		{
			return string.Format("{0}-{1}", value.Start, value.End);
		}

		public static string DoNotCall(bool? value)
		{
			return value.HasValue ? (value.Value ? "Registered" : "Not Registered") : "Unknown";
		}

		public static string LocationSince(LocationAssociation association)
		{
			if (association.IsHistorical)
			{
				return string.Format("{0} - {1}", DateAsMonthYear(association.ValidFor.Start), DateAsMonthYear(association.ValidFor.Stop));
			}
			else
			{
				return string.Format("Current (since {0})", DateAsMonthYear(association.ValidFor.Start));
			}
		}

		public static string DateAsMonthYear(Date value)
		{
			string ms = null;
			var m = value.Month;
			if (m.HasValue)
			{
				var md = new DateTime(2000, m.Value, 1);
				ms = md.ToString("MMMM");
			}
			var y = value.Year.ToString();
			return string.Format("{0} {1}", ms, y);
		}

		public static string DeliveryPoint(Location.LocationDeliveryPoint? value)
		{
			return value == null ? "Unknown" : value.ToString();
		}
	}
}
