require './app/model/config.rb'
require 'simple-rss'
require 'open-uri'

class Reader
  def self.read_feeds
    Reader.feeds.each do |feed|
      articles = Reader.read(feed.url)
      Reader.save_articles(articles, feed.url)
    end
  end

  def self.feeds
    Feed.all
  end

  def self.read(url)
    SimpleRSS.parse open(url)
  end

  def self.save_articles(articles, url)
    articles.items.each do |item|
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


