require "./test/config.rb"
require "./app/model/config.rb"
require "./app/backend/reader.rb"

class TestReader < Test::Unit::TestCase

  def setup
    @url = "http://www.xkcd.com/rss.xml"
  end

  def test_load_feeds
    Feed.first_or_create(:url => @url)

    assert Reader.feeds.count > 0
  end

  def test_feed
    assert Reader.feed(@url).items.length > 0
  end

  def test_save_articles
    articles = Article.all(:feed => @url)
    articles.destroy!
    assert Article.all(:feed => @url).count == 0

    Feed.first_or_create(:url => @url)
    feed = Reader.feed(@url)

    Reader.save_articles(feed, @url)
    assert Article.all(:feed => @url).count > 0
  end

end
