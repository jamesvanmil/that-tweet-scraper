require 'yaml'
require 'twitter'

secrets = YAML.load_file('secrets.yml') ## put your keys here, in YAML format

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = secrets["consumer_key"]
  config.consumer_secret     = secrets["consumer_secret"]
  config.access_token        = secrets["access_token"]
  config.access_token_secret = secrets["access_token_secret"]
end

puts client.search("#thatcampuc").first.text
