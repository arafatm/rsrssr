require './app/web/main.rb'
require 'test/unit'
require 'rack/test'
require 'json'

class MainTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_get_articles
    get '/articles'
    assert last_response.ok?
    puts last_response.inspect
    last_response.each do |i|
      puts i
    end
    assert JSON.parse(last_response.body).size > 0
  end

end
