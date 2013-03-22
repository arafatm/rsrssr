require "./test/configmodel.rb"
require 'dm-core'
require 'dm-migrations'

class TestArticle < Test::Unit::TestCase

  def setup
    @url = "http://xkcd.com/rss.xml"
  end

  def test_Article_has_attributes_link_title_description_feed
    article = create_yermom_article
    assert article.class == Article
  end

  def test_Article_link_is_unique
    create_yermom_article
    begin
      Article.create(:link => "http://yermomma.com/1185/",
                     :title => "Test Title",
                     :description => "Test Description",
                     :feed => @url)
    rescue Exception => e
      assert e.message == "column link is not unique"
    end
    destroy_yermom_article
  end

  def create_yermom_article
    article = Article.first_or_create(:link => "http://yermomma.com/1185/",
                                      :title => "Test Title",
                                      :description => "Test Description",
                                      :feed => @url)
  end
  def destroy_yermom_article
    Article.get("http://yermomma.com/1185/").destroy!
  end
end
