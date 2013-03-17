require 'simple-rss'
require 'open-uri'

@slashdot = SimpleRSS.parse open('http://slashdot.org/index.rdf')
puts @slashdot
@xkcd = SimpleRSS.parse open('http://xkcd.com/rss.xml')
puts @xkcd
