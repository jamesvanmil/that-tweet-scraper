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

def tweet_limit
  YAML.load_file('config.yml')["number_of_results"]
end

def get_page(client, last_id)
  last_id = last_id - 1 unless last_id.nil?
  begin
    client.search(search_term, max_id: last_id)
  rescue Twitter::Error::TooManyRequests => error
    puts error.rate_limit.reset_in + 1
    sleep error.rate_limit.reset_in + 1
    retry
  end
end

secrets = YAML.load_file('secrets.yml') ## put your keys here, in YAML format

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = secrets["consumer_key"]
  config.consumer_secret     = secrets["consumer_secret"]
  config.access_token        = secrets["access_token"]
  config.access_token_secret = secrets["access_token_secret"]
end

CSV.open(csv_filename, "wb") do |csv|
  @last_id = nil
  search_result_number = 0
  csv << fields ## write header

  while search_result_number < tweet_limit do
    puts @last_id
    page = get_page(client, @last_id)
    search_result_number += page.count
    puts "#{search_result_number} out of #{tweet_limit}"

    page.each do |tweet|
     row = fields.collect do |field|
       puts tweet[field.to_sym]
       tweet[field.to_sym]
     end
     csv << row
     @last_id = tweet.id
    end
  end
end
