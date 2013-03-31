require './app/model/config.rb'
require './app/backend/reader.rb'

DataMapper.auto_migrate!

Feed.first_or_create(:url => 'http://xkcd.com/rss.xml')
Feed.first_or_create(:url => 'http://slashdot.org/index.rdf')

Reader.read_feeds
