require './app/model/config.rb'
require 'simple-rss'
require 'open-uri'

class Reader
  def self.feeds
    Feed.all
  end

  def self.feed(feed)
    SimpleRSS.parse open(feed)
  end

  def self.save_articles(feed)
  end
end


