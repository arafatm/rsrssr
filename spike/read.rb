require 'simple-rss'
require 'open-uri'

rss = SimpleRSS.parse open('http://slashdot.org/index.rdf')
puts rss
