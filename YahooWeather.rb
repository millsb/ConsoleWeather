require('net/http')
require('json')
require('xmlsimple')

class YahooWeather
	
	@@codes
	@@woeid
	@@api_key
	
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

		
		@api_key = "[YOUR_API_KEY_HERE]"
	
		@woeid = GetWOEID(zip)
	end

	def GetWeather()
	
		yahoo_url = URI("http://weather.yahooapis.com/forecastrss?w=#{@woeid.to_s}")

		response = Net::HTTP.get_response(yahoo_url)

		xml_data = XmlSimple.xml_in(response.body)

		return ParseXml(xml_data)
	end

	def ParseXml(xml)

		return_val = ''

		xml['channel'].each do |item|
			item.each do |j|
				if j.to_s.include? '"condition"=>'
					obj = j.to_a
					o = obj[1].to_a[0]
					o['forecast'].each{|x|
						day		= x['day']						
						high	= x['high']
						low		= x['low']
						code	= @codes[x['code'].to_i]

						return_val << "#{day} (#{high}/#{low}) #{code}\n"
					}
				end
			end
		end

		return return_val
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

		# test for api
		if @api_key == '[YOUR_API_KEY_HERE]' then
			puts 'no api key set'	
			return
		end

		if (zip != "" || zip != null)
			
			yahoo_url = URI("http://where.yahooapis.com/v1/places.q('" + zip + "')?format=json&appid=#{@api_key}")
			
			response = Net::HTTP.get_response(yahoo_url)

			json_data = JSON.parse(response.body)

			id = json_data['places']['place'][0]['woeid'];	
		end
		
		return id
	end

end
