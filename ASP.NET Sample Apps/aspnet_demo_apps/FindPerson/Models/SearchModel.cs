using System;
using System.Text.RegularExpressions;

namespace FindPerson.Models
{
	public class SearchModel
	{
		private string _name;
		private string _address;
		private string _where;
		private string _city;
		private string _state;
		private string _zip;

		public string LastName 
		{ 
			get
			{
<<<<<<< HEAD
				if (_name.Contains(" "))
=======
				if (!string.IsNullOrWhiteSpace(_name) && (_name.Contains(" ")))
>>>>>>> f987985d0334788b0ee79ea1e779a8e380951bf1
				{
					return _name.Substring(_name.IndexOf(" ", StringComparison.InvariantCultureIgnoreCase) + 1);
				}
				return _name;
			}
		}

		public string FirstName
		{
			get
			{
<<<<<<< HEAD
				if (_name.Contains(" "))
=======
				if (!string.IsNullOrWhiteSpace(_name) && (_name.Contains(" ")))
>>>>>>> f987985d0334788b0ee79ea1e779a8e380951bf1
				{
					return _name.Substring(0, _name.IndexOf(" ", StringComparison.InvariantCultureIgnoreCase));
				}
				return _name;
			}
		}

		public string Name
		{
			get { return _name; }
			set { _name = value; }
		}

		public string Address
		{
			get { return _address; }
			set { _address = value; }
		}

		public string Where
		{
			get { return _where; }
			set
			{
				_where = value;
				var city = _where;
				var state = _where;
				var zip = _where;
				var pat = "^\\d.*";
				if (Regex.IsMatch(_where, pat))
				{
					_zip = _where.Trim();
					state = "";
					city = "";
				}
				else
				{
					// do we have a state?
					pat = ".*\\s*(?<state>[A-Za-z]{2})\\s*.*";
					if (Regex.IsMatch(_where, pat))
					{
<<<<<<< HEAD
=======
						var wlen = _where.Length;
>>>>>>> f987985d0334788b0ee79ea1e779a8e380951bf1
						var regex = new Regex(pat);
						var match = regex.Match(_where);
						state = match.Groups["state"].Value;
						var index = _where.IndexOf(state, StringComparison.InvariantCultureIgnoreCase);
						city = _where.Substring(0, index - 1).Trim();
<<<<<<< HEAD
						zip = _where.Substring(index + state.Length + 1).Trim();
=======
						city = city.TrimEnd(new char[2] {' ', ','});
						var proposedZipStart = index + state.Length;
						if (proposedZipStart > wlen)
						{
							zip = _where.Substring(proposedZipStart).Trim();
						}
						else
						{
							zip = "";
						}
>>>>>>> f987985d0334788b0ee79ea1e779a8e380951bf1
					}
					else
					{
						// no state
						// is there a numeric zip code at the end?
						pat = ".*(?<zip>\\d{5})\\s*$";
						if (Regex.IsMatch(_where, pat))
						{
							var regex = new Regex(pat);
							var match = regex.Match(_where);
							zip = match.Groups["zip"].Value;
							var idx = _where.IndexOf(zip, StringComparison.InvariantCultureIgnoreCase);
							city = _where.Substring(0, idx - 1);
							state = "";
						}
						else
						{
							// no state, no zip: all is city
							city = _where;
							state = "";
							zip = "";
						}
					}

				}
				_city = city;
				_state = state;
				_zip = zip;
			}
		}

		public string City
		{
			get { return _city; }
		}

		public string State
		{
			get { return _state; }
		}

		public string PostalCode
		{
			get { return _zip; }
		}

	}
}
