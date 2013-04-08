# encoding: UTF-8
require 'sinatra'
require 'json'
require './app/model/config.rb'

get '/articles' do
  Article.all
  {:bar => "foo"}.to_json
end

# ruby main.rb -e production/test/development to see environment
get '/environment' do
  if development?
    "development" 
  elsif production?
    "production" 
  elsif test?
    "test" 
  else
    "Who knows what environment you're in!"
  end
end
