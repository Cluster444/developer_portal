require 'spec_helper'

describe SyndicationCategory do
  before :each do
    @attr = {:title => 'a'}
  end

  it 'should create an entry with valid attributes' do
    SyndicationCategory.create! @attr
  end
end
