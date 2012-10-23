require('./YahooWeather.rb')
require('xmlsimple')
require('net/http')

zip = ARGV[0]

#yahoo = YahooWeather.new(zip)

#puts yahoo.GetWeather

url = URI('http://weather.yahooapis.com/forecastrss?w=2502265')

response = Net::HTTP.get_response(url)

xml_data = XmlSimple.xml_in(response.body)

xml_data['channel'].each do |item|
	item.each do |j|
		puts j
	end
end
