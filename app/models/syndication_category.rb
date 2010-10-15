# == Schema Information
# Schema version: 20101015040522
#
# Table name: syndication_categories
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  parent_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class SyndicationCategory < ActiveRecord::Base
  attr_accessible :title

  acts_as_tree

  has_and_belongs_to_many :syndications, :class_name => 'Syndication'

  validates :title, :presence => true,
                    :uniqueness => true
  
  def syndication_count
    count = 0
    self.syndications.each do |s|
      count += 1 if s.live?
    end
    count
  end
end
