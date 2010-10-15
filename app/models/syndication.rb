# == Schema Information
# Schema version: 20101015040522
#
# Table name: syndications
#
#  id           :integer(4)      not null, primary key
#  title        :string(255)
#  description  :text
#  url          :string(255)
#  protocol     :string(255)
#  content_type :string(255)
#  spam         :boolean(1)
#  state        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Syndication < ActiveRecord::Base
  attr_accessor :syndication_category_id
  attr_accessible :title, :description, :url, :protocol, :content_type
  
  #FIXME Doesn't like submissions with no email
  #filters_spam :message_field => :description,
  #             :author_field => :title

  has_and_belongs_to_many :categories, :class_name => 'SyndicationCategory'

  validates :title, :presence => true, 
                    :uniqueness => {:case_sensitive => false},
                    :length => {:maximum => 255}

  validates :description, :length => {:maximum => 4096} # 4KB

  validates :url, :presence => true,
                  :uniqueness => {:case_sensitive => false},
                  :length => {:maximum => 255},
                  :format => {:with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix}
  
  #TODO Validate url is reachable
  #TODO Validate existing category_id

  validates :protocol, :presence => true,
                       :inclusion => {:in => RefinerySetting.find_or_set(:syndication_protocols, %w(RSS-2.0 Atom-1.0))}
  
  validates :content_type, :presence => true,
                           :inclusion => {:in => RefinerySetting.find_or_set(:syndication_types, %w(Blog Forum News Event))}

  scope :unmoderated, :conditions => {:state => nil}
  scope :approved, :conditions => {:state => 'approved'}
  scope :rejected, :conditions => {:state => 'rejected'}

  # fitlers_spam adds
  # spam! / ham! to set spam true/false
  # spam? / ham? to find the value

  def approve!
    self.update_attribute :state, 'approved'
  end

  def reject!
    self.update_attribute :state, 'rejected'
  end

  def approved?
    self.state = 'approved'
  end

  def rejected?
    self.state = 'rejected'
  end

  def unmoderated?
    self.state.nil?
  end

  before_create :attach_to_root_category

  before_create do |feed|
    unless Syndication::Moderation.enabled?
      feed.state = feed.spam? ? 'rejected' : 'approved'
    end
  end

  def attach_to_root_category
    self.categories=[SyndicationCategory.root] unless SyndicationCategory.root.nil?
  end

  module Moderation
    class << self
      def enabled?
        RefinerySetting.find_or_set(:syndication_moderation, true, {
          :scoping => :syndication,
          :restricted => :false,
          :callback_proc_as_string => nil
        })
      end

      def toggle!
        RefinerySetting[:syndication_moderation] = {
          :value => !self.enabled?,
          :scoping => :syndication,
          :restricted => false,
          :callback_proc_as_string => nil
        }
      end
    end
  end

  module Notification
    class << self
      def recipients
        RefinerySetting.find_or_set(:syndication_notification_recipients,
                                    (Role[:refinery].users.first.email rescue ''),
                                    {
                                      :scoping => :syndication,
                                      :restricted => false,
                                      :callback_proc_as_string => ''
                                    })
      end

      def recipients=(emails)
        RefinerySetting[:syndication_notification_recipients] = {
          :value => emails,
          :scoping => :syndication,
          :restricted => false,
          :callback_proc_as_string => ''
        }
      end
    end
  end
end
