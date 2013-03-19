require "./test/configmodel.rb"
require 'dm-core'
require 'dm-migrations'

class TestArticle < Test::Unit::TestCase

  def setup
    @url = "http://xkcd.com/rss.xml"
  end

  def has_attributes_link_title_description_feed
    article = create_article
    assert article.class == Article
  end
  def test_link_is_unique
    create_article
    begin
      Article.create(:link => "http://xkcd.com/1185/",
                     :title => "Test Title",
                     :description => "Test Description",
                     :feed => @url)
    rescue Exception => e
      assert e.message == "column link is not unique"
    end
  end

  def create_article
    Article.first_or_create(:link => "http://xkcd.com/1185/",
                            :title => "Test Title",
                            :description => "Test Description",
                            :feed => @url)
  end
end
