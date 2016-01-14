namespace ReverseAddress.Models
{
	public class LocationResult
	{
		public string StreetAddress1 { get; set; }
		public string StreetAddress2 { get; set; }
		public string City { get; set; }
		public string StateCode { get; set; }
		public string PostalCode { get; set; }
		public bool IsDeliverable { get; set; }
		public string Usage { get; set; }
		public string DeliveryPoint { get; set; }
	}
}
