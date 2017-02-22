# Requiring needed items to complete the task

    # Nokoigigi is used to parse and manipulate data
require 'nokogiri'
    # This is not a gem simply part of nokogiri to open things
require 'open-uri'
    # This is the server we will be using so we can iniciate a server and write files to it
require 'redis'
    # This is used to unzip the folders so we can get the files inside
require 'zip'

# Makes my new redis instance
redis_file = Redis.new
# Sets the URL we are using to get the list of files from
    # I used the full URL rather than the provided bitly URL for optimization. That way it doesnt have to re route to the full URL
nuvi_url = 'http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/'

# create folder variable and have Nokogiri store all the foldrs from the url to it
folders = Nokogiri::HTML(open(nuvi_url))
    .xpath('//a')
    .map { |link| nuvi_url + link["href"] if link["href"].include?(".zip") }.compact()
# Sets the files from nokogiri equal only if they end in .zip
# .compact() is used to remove any nil elements, such as the 5 links at the start that aren't .zip files (Name, Last Motified, Size Description and Parent Directory)
# Possibly use soemthing like .uniq latter on to check the file title to make sure its unique and dont duplicating items on the list

# this just tells me how many colders there are @nuvi_url
puts "There is a total of #{folders.count} folders that we are checking, hold tight"

# Each folder with an index (value) will have this run
folders.each_with_index do |folder, current|
    # Tells which folder we are working on currently, the plus one just adds 1 to the current folder since folder 0 for the first would just seem weird
    puts "Currently Working on folder #{current+1} of #{folders.count}"
    # This Opens the current folder and unzips it so we can get the files
    Zip::File.open(open(folder)) do |unzipped_folder|
        # Tells us how many files are in the folder we just unzipped
        print "Downloaded #{unzipped_folder.count} files from folder #{current+1} "
        # This will run for each file in the unzipped folder
        unzipped_folder.each_with_index do |file|
            # This removes anything the file if it is already there to make the application idempotent
            redis_file.lrem('NEWS_XML', -1, file.get_input_stream.read)
            # If it passed above and isnt a dublicate it will push the file to the NEWS_XML List
            redis_file.lpush('NEWS_XML', file.get_input_stream.read)
        end
    end
end
