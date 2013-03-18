require "./test/config.rb"
require "./app/model/config.rb"
require "./app/backend/read.rb"

class TestRead < Test::Unit::TestCase

  def setup
    @url = "http://www.xkcd.com/rss.xml"
  end

  def test_load_feeds
    Feed.first_or_create(:url => @url)
    feeds = Read.feeds
    assert feeds.count > 0
  end

  def test_feed
    articles = Read.articles(@url)
    assert articles.items.length > 0
  end

  def test_save_articles
    pend "Given feed, save articles"
  end

end
