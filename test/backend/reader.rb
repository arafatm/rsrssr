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

    feed = sample_articles

    Reader.save_articles(feed, @url)
    assert Article.all(:feed => @url).count > 0
  end

  def test_Reader_saves_article_attributes_link_title_description_feed_pubDate
    articles = Article.all(:feed => @url)
    articles.destroy!

    feed = sample_articles

    Reader.save_articles(feed, @url)
    article = Article.first

    assert article.link.length > 0
    assert article.title.length > 0
    assert article.description.length > 0
    assert article.feed.length > 0
    assert article.pubDate.year > 0
  end

  def test_Reader_wont_raise_Exception_when_trying_to_insert_duplicate_article

    feed = sample_articles

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

  def sample_articles
    article = <<-article
      <?xml version="1.0" encoding="utf-8"?>

      <rss version="2.0">
        <channel>
          <title>xkcd.com
          </title>
          <link>http://xkcd.com/
          </link>
          <description>xkcd.com: A webcomic of romance and math humor.
          </description>
          <language>en
          </language>
          <item>
            <title>Bonding</title>
            <link>http://xkcd.com/1188/</link>
            <description>&lt;img src="http://imgs.xkcd.com/comics/bonding.png" title="I'm trying to build character but Eclipse is really confusing." alt="I'm trying to build character but Eclipse is really confusing." /&gt;</description>
            <pubDate>Wed, 20 Mar 2013 04:00:00 -0000</pubDate>
            <guid>http://xkcd.com/1188/</guid>
          </item>
          <item>
            <title>Aspect Ratio
            </title>
            <link>http://xkcd.com/1187/
            </link>
            <description>&lt;img src="http://imgs.xkcd.com/comics/aspect_ratio.png" title="I'm always disappointed when 'Anamorphic Widescreen' doesn't refer to a widescreen Animorphs movie." alt="I'm always disappointed when 'Anamorphic Widescreen' doesn't refer to a widescreen Animorphs movie." /&gt;
            </description>
            <pubDate>Mon, 18 Mar 2013 04:00:00 -0000
            </pubDate>
            <guid>http://xkcd.com/1187/
            </guid>
          </item>
          <item>
            <title>Bumblebees
            </title>
            <link>http://xkcd.com/1186/
            </link>
            <description>&lt;img src="http://imgs.xkcd.com/comics/bumblebees.png" title="Did you know sociologists can't explain why people keep repeating that urban legend about bumblebees not being able to fly!?" alt="Did you know sociologists can't explain why people keep repeating that urban legend about bumblebees not being able to fly!?" /&gt;
            </description>
            <pubDate>Fri, 15 Mar 2013 04:00:00 -0000
            </pubDate>
            <guid>http://xkcd.com/1186/
            </guid>
          </item>
          <item>
            <title>Ineffective Sorts
            </title>
            <link>http://xkcd.com/1185/
            </link>
            <description>&lt;img src="http://imgs.xkcd.com/comics/ineffective_sorts.png" title="StackSort connects to StackOverflow, searches for 'sort a list', and downloads and runs code snippets until the list is sorted." alt="StackSort connects to StackOverflow, searches for 'sort a list', and downloads and runs code snippets until the list is sorted." /&gt;
            </description>
            <pubDate>Wed, 13 Mar 2013 04:00:00 -0000
            </pubDate>
            <guid>http://xkcd.com/1185/
            </guid>
          </item>
        </channel>
      </rss>
    article
    SimpleRSS.parse(article)
  end

end
