https://github.com/CosmicCat/solace-sounds-ripper

JUSTIFICATION
I really enjoy DJ Ciaran Begley's Trance mixes, but I need an internet connection
to do so. Furthermore, streaming through a web browser does not want to work in
Ubuntu linux, rendering this music inaccessible when my productivity needs it
the most. This script downloads the entire 70+ series of Solace Sounds by scraping
his IIS server for urls and then ripping them.

LEGALITY/ETHICS
Grey. I would suggest not sharing/posting aquired mp3s.

BEFORE RUNNING
* need to have ruby 1.9.3x
* install ruby gems
 * nokogiri (for scraping)
 * mp3info (tag editing)
* install streamripper (streamripper.sourceforge.net)

USAGE
 * edit the DESTINATION_DIR to something appropriate for you
 * run the script 'ruby solace-sounds-ripper.rb'

NOTES
 * script is fragile. It will die if the slightest thing is amiss.
 * I had to do some silly things to get this to work with streamripper
 * I have no idea if anyone else will find this useful. Please contact
   me if you have trouble with it.
 * my ruby is padawan. If you think this script is ugly, tell me why.

LICENSE
 The I would be delighted if you told me you found this useful license.
