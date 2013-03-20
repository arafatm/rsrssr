require './app/model/config.rb'
require 'simple-rss'
require 'open-uri'

class Reader
  def self.feeds
    Feed.all
  end

  def self.feed(url)
    SimpleRSS.parse open(url)
  end

  def self.save_articles(feed, url)
    feed.items.each do |item|
      Article.first_or_create(:link => item.link,
                              :title => item.title,
                              :description => item.description,
                              :feed => url)
    end
  end
end


