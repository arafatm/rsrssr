require "./test/config.rb"
require 'dm-core'
require 'dm-migrations'
require './app/model/config.rb'

class TestFeed < Test::Unit::TestCase

  def setup
    @url = "http://xkcd.com/rss.xml"
  end

  def test_Feed_has_attribute_url
    feed = Feed.first_or_create(:url => @url)
    assert_equal feed.url, @url
  end

  def test_Feed_url_is_unique
    Feed.first_or_create(:url => @url)
    begin
      Feed.create(:url => @url)
    rescue Exception => e
      assert e.message == "column url is not unique"
    end
  end
end
