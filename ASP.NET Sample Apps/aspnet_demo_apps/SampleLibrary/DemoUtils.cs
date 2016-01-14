using System;
using ProApiLibrary.Data.Entities;

namespace SampleLibrary
{
	public static class DemoUtils
	{
		public static string ReputationLevelAsString(int? level)
		{
			switch (level)
			{
				case null:
				{
					return "Unknown";
				}
				case 1:
				{
					return "Not Spam";
				}
				case 2:
				case 3:
				{
					return "Moderate Risk";
				}
				default:
				{
					return "High Risk";
				}
			}
		}

		public static string FormatDateAsMonth(Date date)
		{
			var result = "?";
			if (date != null)
			{
				var actualDate = date.Value;
				result = actualDate.ToString("MMMM, yyyy");
			}
			return result;
		}

		public static string GetDisplayDuration(Date date)
		{
			var result = "?";
			if (date != null)
			{
				var then = date.Value;
				var now = DateTime.Now;
				var diffYear = now.Year - then.Year;
				if (diffYear >= 2)
				{
					result = String.Format("about {0} years", diffYear);
				}
				else
				{
					var diffDuration = now - then;
					var approximateMonths = (int) (diffDuration.TotalDays/30.0);
					result = String.Format("{0} months", approximateMonths);
				}
			}
			return result;
		}

		public static string GetTimePeriodDisplay(TimePeriod period)
		{
			var result = "?";
			if (period != null)
			{
				var start = period.Start;
				var stop = period.Stop;
				if ((start != null) 
					&& (stop != null))
				{
					var startDate = start.Value;
					var stopDate = stop.Value;
					var span = stopDate - startDate;
					var totalDays = span.TotalDays;
					var totalMonths = (int) (totalDays/30.0);
					var totalYears = totalMonths/12;
					if (totalMonths == 0)
					{
						result = "";
					}
					else if (totalYears > 0)
					{
						var remainingMonths = totalMonths%12;
						result = String.Format("({0} year{1}, {2} month{3})", totalYears, (totalYears == 1) ? "" : "s", remainingMonths,
						                       (remainingMonths == 1) ? "" : "s");
					}
					else
					{
						result = String.Format("({0} month{1})", totalMonths, (totalMonths == 1) ? "" : "s");
					}
				}
			}
			return result;
		}
	}
}
