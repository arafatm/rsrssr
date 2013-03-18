class Article
  include DataMapper::Resource

  property :link,   String, :key => true
  property :title,  String
  property :description,  String
  property :feed,   String

end
