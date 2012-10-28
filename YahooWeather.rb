require('net/http')
require('json')
require('xmlsimple')

# It's worth taking the time to learn Bundler for depdency management
# and use the standard RubyGem stucture.
#
# (On *nix)
# $ bundle gem // generates a blank gem file/folder
# $ bundle install // installs dependencies specified in .gemspec file
#
# Note: Using bundle is for managing installation of dependencies. You
# will still need to use the require statements

class YahooWeather
	
	# @@codes
	# @@woeid
	# @@api_key

    # It looks like you're declaring class variables here as if they were class properties in another language.
    # That's not really how class vars work, and when this program runs, they're never actually assigned any
    # values. 
    #
    # @@ - declares a *class* variable, which is shared between *all* instances of a class. This means they're
    # essentially global. It always belongs to the parent, and modifications will affect all child classes.
    #
    # @ - delcares an instance variable, which are scoped to a single given instance of the class, and is
    # basically like class properties in other languages. You don't need to declare them prior to usage, and
    # they're protected by default. If you want to generate get or set or get/set methods for them, use attr_getter, 
    # attr_setter, or attr_accessor, respectively.

    # I think @api_key and @code are actually better suited as class constants rather than instances vars
    # So let's only declare :woeid as a property, with a getter
    attr_getter :woeid

    API_KEY = "[YOUR_API_KEY_HERE]"
    CODES = 
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
	
	def initialize(zip)
		@woeid = GetWOEID(zip)
	end

	def GetWeather()
	
        # probably don't need to typecase @woeid as a string here (or anywhere else)
        # Ruby is a duck typed language, ans pretty good at conversion
		yahoo_url = URI("http://weather.yahooapis.com/forecastrss?w=#{@woeid.to_s}")

		response = Net::HTTP.get_response(yahoo_url)

		xml_data = XmlSimple.xml_in(response.body)

		return ParseXml(xml_data)
	end

	def ParseXml(xml)

        # make this an array of lines. In console output,
        # using "puts" will automatically add a newline character
        # at the end of each call
		return_val = []

        # Again, I'm not sure you need to do as much typecasting as you do
        # here. Especially for something like the code, whihc you convert
        # to an Integer right before it goes into a String.
        #
        # Also, not terribly familiar with xmlsimple or the Yahoo output, but there should
        # be some way to parse it so that you get some kind of data
        # structure returned, and you don't have to test against a string
        # or do manual casts to arrays

		xml['channel'].each do |item|
			item.each do |j|
				if j.to_s.include? '"condition"=>'
					obj = j.to_a
					o = obj[1].to_a[0]
					o['forecast'].each{|x|
						return_val << print_weather(x)
					}
				end
			end
		end

		return return_val
	end

    # the return keyword in Ruby is optional. Methods will default to returning
    # return the last expression evaluated.
    def print_weather(w)
      "#{w['day']} (#{w['high']}/#{w['low']} #{GetWeatherCode(w['code']}"
    end
	
    # to make methods private or protected, just use put them after
    # the private/protected keyword
    
    private
	# TODO: make private
	# getter for yahoo weather code
	def GetWeatherCode(code)
		return CODES[code].to_s
	end
		
	# TODO: make private
	# gets the woeid and returns it based on a zip search
	def GetWOEID(zip)
	
		id = nil

		# test for api
        # The 'then' keyword is optional, and usually omitted
		if API_KEY == '[YOUR_API_KEY_HERE]' || API_KEY.empty?
          # seems like a good place for an Exception
          raise "no api key set"
		end

        # in Ruby, "null is not a keyword. We should use "nil" here instead
        # Even better, we can use "empty?" to test if nil or an empty String.
		if zip.empty?
			
			yahoo_url = URI("http://where.yahooapis.com/v1/places.q('" + zip + "')?format=json&appid=#{@api_key}")
			
			response = Net::HTTP.get_response(yahoo_url)

			json_data = JSON.parse(response.body)

			id = json_data['places']['place'][0]['woeid'];	
		end
		
		return id
	end

end
