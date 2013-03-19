require './app/model/config.rb'

Feed.first_or_create(:url => 'http://xkcd.com/rss.xml')
Feed.first_or_create(:url => 'http://slashdot.org/index.rdf')
