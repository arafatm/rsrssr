require './app/model/config.rb'
require 'simple-rss'
require 'open-uri'

class Reader
  def self.read_feeds
    Reader.feeds.each do |feed|
      articles = Reader.feed(feed.url)
      Reader.save_articles(articles, feed.url)
    end
  end

  def self.feeds
    Feed.all
  end

  # TODO: rename read
  def self.feed(url)
    SimpleRSS.parse open(url)
  end

  # TODO: rename feed => articles
  def self.save_articles(feed, url)
    feed.items.each do |item|
      begin
        Article.create(:link => item.link,
                       :title => item.title,
                       :description => item.description,
                       :feed => url)
      rescue DataObjects::IntegrityError => e
      end
    end
  end
end


