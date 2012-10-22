require('net/http')
require('json')

class YahooWeather
	
	@@codes
	@@woeid
	
	def initialize(zip)
		@codes =
		{
			0 => "tornado",
			1 => "tropical storm",
			2 => "hurricane",
			3 => "severe thunderstorms",
			4 => "thunderstorms",
			5 => "mixed rain and snow",
			6 => "mixed rain and sleet",
			7 => "mixed snow and sleet",
			8 => "freezing drizzle",
			9 => "drizzle",
			10 => "freezing rain",
			11 => "showers",
			12 => "showers",
			13 => "snow flurries",
			14 => "light snow showers",
			15 => "blowing snow",
			16 => "snow",
			17 => "hail",
			18 => "sleet",
			19 => "dust",
			20 => "foggy",
			21 => "haze",
			22 => "smoky",
			23 => "blustery",
			24 => "windy",
			25 => "cold",
			26 => "cloudy",
			27 => "mostly cloudy (night)",
			28 => "mostly cloudy (day)",
			29 => "partly cloudy (night)",
			30 => "partly cloudy (day)",
			31 => "clear (night)",
			32 => "sunny",
			33 => "fair (night)",
			34 => "fair (day)",
			35 => "mixed rain and hail",
			36 => "hot",
			37 => "isolated thunderstorms",
			38 => "scattered thunderstorms",
			39 => "scattered thunderstorms",
			40 => "scattered showers",
			41 => "heavy snow",
			42 => "scattered snow showers",
			43 => "heavy snow",
			44 => "partly cloudy",
			45 => "thundershowers",
			46 => "snow showers",
			47 => "isolated thundershowers",
			3200 => "not available" 
		}

		@woeid = GetWOEID(zip)
	end

	def GetWeather()
	
		yahoo_url = URI("http://weather.yahooapis.com/forecastrss?w=" + @woeid)

		response = Net::HTTP.get_response(yahoo_url)

		# TODO: finish here -> must parse XML not JSON

	end
	
	# TODO: make private
	# getter for yahoo weather code
	def GetWeatherCode(code)
		return @codes[code].to_s
	end
		
	# TODO: make private
	# gets the woeid and returns it based on a zip search
	def GetWOEID(zip)
	
		id = nil

		if (zip != "" || zip != null)
			
			yahoo_url = URI("http://where.yahooapis.com/v1/places.q('" + zip + "')?format=json&appid=4104c62c15d56ace9f895c36abe0d56f0ffadd67")
			
			response = Net::HTTP.get_response(yahoo_url)

			json_data = JSON.parse(response.body)

			id = json_data['places']['place'][0]['woeid'];	
		end
		
		return id
	end

end