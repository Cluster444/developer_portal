require 'spec_helper'

describe Syndication do
  before :each do
    @cat = Factory :syndication_category
    @attr = {
      :title => 'Test',
      :url => 'http://www.foo.com/forum/feed.rss',
      :protocol => 'RSS-2.0',
      :content_type => 'Forum',
    }
  end

  it 'should create a new entry with valid attributes' do
    Syndication.create! @attr
  end

  it 'should require a title' do
    s = Syndication.new @attr.merge(:title => nil)
    s.should_not be_valid
  end

  it 'should have a unique title regardless of case' do
    Syndication.create! @attr
    s = Syndication.new @attr.merge(:title => 'test', :url => 'http://www.bar.com/feed.rss')
    s.should_not be_valid
    # Change the url to prevent a false positive
  end

  it 'should reject long titles' do
    long_title = 'a' * 256
    s = Syndication.new @attr.merge(:title => long_title)
    s.should_not be_valid
  end

  it 'should reject long descriptions' do
    long_desc = 'a' * 4097
    s = Syndication.new @attr.merge(:description => long_desc)
    s.should_not be_valid
  end
  
  it 'should require a url' do
    s = Syndication.new @attr.merge(:url => nil)
    s.should_not be_valid
  end

  it 'should have a unique url regardless of case' do
    Syndication.create! @attr
    s = Syndication.new @attr.merge(:title => 'TestUrl', :url => 'http://www.foo.com/FoRuM/feed.rss')
    s.should_not be_valid
    # Change the title to prevent a false positive
  end

  it 'should reject a long url' do
    long_url = 'a' * 256
    s = Syndication.new @attr.merge(:url => long_url)
    s.should_not be_valid
  end

  it 'should have a well formed url' do
    bad_urls = %w(
      http:/foo.bar.com/feed.rss
      http://foobarcom/feed.rss
      http//foo.bar.com/feed.rss
    )
    bad_urls.each do |url|
      s = Syndication.new @attr.merge(:url => url)
      s.should_not be_valid
    end
  end

  it 'should have a url that is reachable'
  
  it 'should require a protocol' do
    s = Syndication.new @attr.merge(:protocol => nil)
    s.should_not be_valid
  end

  it 'should have an acceptable protocol' do
    RefinerySetting.find_or_set(:syndication_protocols, %w(RSS-2.0 Atom-1.0))
    s = Syndication.new @attr.merge(:protocol => 'RSS-0.92')
    s.should_not be_valid
  end
  
  it 'should require a content type' do
    s = Syndication.new @attr.merge(:content_type => nil)
    s.should_not be_valid
  end

  it 'should have an acceptable content type' do
    RefinerySetting.find_or_set(:syndication_types, %w(Blog Forum Event News))
    s = Syndication.new @attr.merge(:content_type => 'foobar')
    s.should_not be_valid
  end

  describe 'scopes' do
    before :each do
      @unmoderated = Factory :syndication
      @approved = Factory :syndication, :title => Factory.next(:title), :url => Factory.next(:url)
      @rejected = Factory :syndication, :title => Factory.next(:title), :url => Factory.next(:url)
      @approved.approve!
      @rejected.reject!
    end
    
    it 'should provide access to unmoderated feeds' do
      s = Syndication.unmoderated
      s.should have(1).record
      s.first.id == @unmoderated.id
    end

    it 'should provide access to approved feeds' do
      s = Syndication.approved
      s.should have(1).record
      s.first.id == @approved.id
    end

    it 'should provide access to rejected feeds' do
      s = Syndication.rejected
      s.should have(1).record
      s.first.id == @rejected.id
    end
  end
end
