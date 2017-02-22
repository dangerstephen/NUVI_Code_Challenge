require 'nokogiri'
require 'open-uri'
require 'redis'
require 'zip'

redis_file = Redis.new
nuvi_url = 'http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/'

folders = Nokogiri::HTML(open(nuvi_url))
    .xpath('//a')
    .map { |link| nuvi_url + link["href"] if link["href"].include?(".zip") }.compact()
puts "There is a total of #{folders.count} folders that we are checking, hold tight"

folders.each_with_index do |folder, current|
    puts "Currently Working on folder #{current+1} of #{folders.count}"
    Zip::File.open(open(folder)) do |unzipped_folder|
        print "Downloaded #{unzipped_folder.count} files from folder #{current+1} "
        unzipped_folder.each_with_index do |file|
            redis_file.lrem('NEWS_XML', -1, file.get_input_stream.read)
            redis_file.lpush('NEWS_XML', file.get_input_stream.read)
        end
    end
end
