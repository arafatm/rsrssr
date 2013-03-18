require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

require './app/model/feed.rb'
require './app/model/article.rb'

DataMapper.auto_upgrade!
DataMapper.finalize


