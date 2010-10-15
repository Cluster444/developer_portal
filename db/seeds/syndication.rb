User.all.each do |user|
  user.plugins.create(:name => 'syndications',
                      :position => (user.plugins.maximum(:position) || -1) +1)
end

page = Page.create(
  :title => 'Syndication Feeds',
  :link_url => '/feeds',
  :deletable => false,
  :position => ((Page.maximum(:position, :conditions => {:parent_id => nil}) || -1) +1),
  :menu_match => "^/feeds.*$"
)

Page.default_parts.each do |default_page_part|
  page.parts.create(:title => default_page_part, :body => nil)
end

SyndicationCategory.create(
  :title => "Syndications"
)
