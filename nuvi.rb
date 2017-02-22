require 'nokogiri'
require 'open-uri'
require 'redis'

# Makes my new redis file
redis_file = Redis.new

# Sets the URL we are using to get the list of files from
nuvi_url = 'http://bitly.com/nuvi-plz'

# Set the files equal to a list and have Nokogiri go to the site to get the elements
file_list = Nokogiri::HTML(open(nuvi_url))

# Sets the files from nokogiri equal to a variable if it ends in .zip
# .compact() is a ruby method that will remove any nil items, such as the links at the start that aren't zips
files = file_list.css("a").map{|link| link["href"] if link["href"].include?(".zip")}.compact()
    # Possibly use soemthing like .uniq latter on to check the file title to make sure its unique and dont duplicating items on the list

puts "There are a total of #{files.count} zipped files that we will be checking today"
