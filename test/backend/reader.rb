require "./test/config.rb"
require "./app/model/config.rb"
require "./app/backend/reader.rb"

class TestReader < Test::Unit::TestCase

  def setup
    @url = "http://www.xkcd.com/rss.xml"
  end

  def test_Reader_can_load_a_feed_from_DB_given_url
    Feed.first_or_create(:url => @url)

    assert Reader.feeds.count > 0
  end

  def test_Reader_can_read_an_RSS_feed_given_the_url
    assert Reader.read(@url).items.length > 0
  end

  def test_Reader_can_save_articles_in_DB
    articles = Article.all(:feed => @url)
    articles.destroy!
    assert Article.all(:feed => @url).count == 0

    Feed.first_or_create(:url => @url)
    feed = Reader.read(@url)

    Reader.save_articles(feed, @url)
    assert Article.all(:feed => @url).count > 0
  end

  def test_Reader_wont_raise_Exception_when_trying_to_insert_duplicate_article
    Feed.first_or_create(:url => @url)
    feed = Reader.read(@url)

    Reader.save_articles(feed, @url)
    Reader.save_articles(feed, @url)
    assert Article.all(:feed => @url).count > 0
  end

  def test_Reader_can_read_all_feeds_in_DB
    Feed.all.destroy!
    Article.all.destroy!

    Feed.create(:url => @url)
    Feed.create(:url => "http://rss.slashdot.org/Slashdot/slashdot")

    Reader.read_feeds

    assert Article.all.count > 0
    assert Article.all(:fields => [:feed], :unique => true).count == 2
  end

end
