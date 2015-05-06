require 'yaml'
require 'twitter'
require 'csv'

def search_term
  YAML.load_file('config.yml')["search_term"]
end

def fields
  YAML.load_file('config.yml')["fields"]
end

def csv_filename
  YAML.load_file('config.yml')["csv_file_name"]
end

secrets = YAML.load_file('secrets.yml') ## put your keys here, in YAML format

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = secrets["consumer_key"]
  config.consumer_secret     = secrets["consumer_secret"]
  config.access_token        = secrets["access_token"]
  config.access_token_secret = secrets["access_token_secret"]
end

search = client.search(search_term)

CSV.open(csv_filename, "wb") do |csv|
  csv << fields
  search.each do |tweet|
   row = fields.collect { |field| tweet[field.to_sym] }
   csv << row
  end
end
