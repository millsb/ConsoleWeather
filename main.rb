require('./YahooWeather.rb')
require('xmlsimple')
require('net/http')

zip = ARGV[0]

yahoo = YahooWeather.new(zip)

puts yahoo.GetWeather

