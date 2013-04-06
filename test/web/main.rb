require './app/web/main.rb'
require 'test/unit'
require 'rack/test'

#ENV['RACK_ENV'] = 'development'

class MainTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_root
    get '/'
    assert last_response.ok?
    assert_equal 'Hello World', last_response.body
  end

end
