Factory.define :syndication_category do |f|
  f.title 'Test Category'
  f.parent_id '1'
end

Factory.define :syndication do |f|
  f.title 'Test Syndication'
  f.url 'http://somedomain.com/feed.rss'
  f.content_type 'Blog'
  f.protocol 'RSS-2.0'
end

Factory.sequence :title do |n|
  "Test-#{n}"
end

Factory.sequence :url do |n|
  "http://test.com/feed#{n}.rss"
end
