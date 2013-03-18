class Feed
  include DataMapper::Resource

  property :url, String, :key => true
end

