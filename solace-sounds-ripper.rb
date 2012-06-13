require 'nokogiri'
require 'open-uri'
require 'mp3info'

# NOTE
# install gems before running
# nokogiri, mp3info

# Usage: just run it. It will take days to download the whole set. You can 
# kill the process at any point and it will start up where it left off.

# Path where we want the completed tracks to go. Probably the only thing
# that should be tweaked.
# Don't use a tilde here! Full path please.
DESTINATION_DIR = "/home/wompoo/Music/SolaceSounds"

HOST = "http://91.186.15.177"
START_URI = "#{HOST}/SolaceSounds/"

# -k 0 tells streamripper to start recording immediately
# -c tells streamripper to exit after disconnect. The server disconnects at the
#    end of the mix, and streamripper reconnects continually without this option.
STREAMRIPPER_APP = "streamripper"
STREAMRIPPER_ARGS = "-k 0 -c"

# This is where streamripper puts its rips. Because the server disconnects at the
# end of the mix, streamripper assumes that the track was incomplete and it never
# gets moved out of this annoying filename with spaces in it. We have to do that
# ourselves.
RIP_FILE = "Streamripper_rips/incomplete/ - .mp3"

# scrape the directory listing to grab the subdirs for each mix.
# Then scrape the subdirs for stream urls.
def main
  doc = Nokogiri::HTML(open(START_URI))
  dirs_to_search = doc.css('a').map{|x|x[:href]}.grep(%r{/SolaceSounds/SolaceSounds})

  streams_to_rip = []

  dirs_to_search.each do |dir|
    puts "Searching #{HOST}#{dir}"

    # don't overwhelm the server
    sleep 1

    subdir = Nokogiri::HTML(open(HOST + dir))
    streams_to_grab = subdir.css('a').map{|x|x[:href]}.grep(%r{\.mp3})
    streams_to_rip.concat(streams_to_grab)
  end

  # we've found all of the mp3 streams, now we grab them
  streams_to_rip.each do |url|
    if stream_already_downloaded(url)      
      puts "skipping url: #{url}"
      next
    end
    rip_stream(url)
    move_ripped_file(url)
    set_mp3_tags(url)
  end
end

def rip_stream(url)
  url = "#{HOST}#{url}"
  puts "*** Ripping the stream at #{url} ***"
  command = "#{STREAMRIPPER_APP} #{url} #{STREAMRIPPER_ARGS}"
  system(command)
  puts "*** Ripping complete. Ignore the complaints from streamripper. ***"
end

def move_ripped_file(url)
  FileUtils.mv("#{RIP_FILE}", stream_url_to_filepath(url))
end

def stream_already_downloaded(url)
  return File.exist?(stream_url_to_filepath(url))
end

def stream_url_to_filepath(url)
  volume_no = %r{.*(\d\d)\.mp3}.match(url)[1]
  return "#{DESTINATION_DIR}/SolaceSounds#{volume_no}.mp3"
end

def set_mp3_tags(url)
  # Unfortunately the implicit file close at the end of the block takes a long time
  # and sometimes sucks up cpu. I can only assume it is because of the large
  # file size of some of these tracks. I tried several different tag editing
  # gems and was not impressed by any of them.
  filename = stream_url_to_filepath(url)
  puts "Setting mp3 tags on #{filename} (sometimes takes a while)"
  name = "Solace Sounds #" + /.*(\d\d)\.mp3/.match(filename)[1]
  Mp3Info.open(filename) do |mp3|
    mp3.tag.title = name
    mp3.tag.album = name
    mp3.tag.artist = "DJ Ciaran Begley"
  end
end

main
