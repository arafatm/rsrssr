DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Feed
  include DataMapper::Resource

  property :url, String, :key => true
end

