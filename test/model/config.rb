require 'dm-core'
require 'dm-migrations'
require './app/model/feed.rb'

DataMapper.auto_upgrade!
DataMapper.finalize


