Factory.define :syndication_category do |f|
  f.title 'Test Category'
  f.parent_id '1'
end

Factory.define :syndication do |f|
  f.title 'Test Syndication'
  f.description '...'
  f.url 'http://somedomain.com/feed.rss'
  f.content_type 'Unknown'
  f.protocol 'RSS 2.0'
  f.category_id '1'
end
