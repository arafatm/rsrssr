require 'dm-core'
require 'dm-migrations'

DataMapper::setup(:default, 
                  ENV['DATABASE_URL'] || 
                  "sqlite3://#{Dir.pwd}/development.db")


require './app/model/feed.rb'
require './app/model/article.rb'

DataMapper::Model.raise_on_save_failure = false

DataMapper.auto_upgrade!
DataMapper.finalize


