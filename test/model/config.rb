require 'dm-core'
require 'dm-migrations'
require './model/feed.rb'

DataMapper.auto_upgrade!
DataMapper.finalize


