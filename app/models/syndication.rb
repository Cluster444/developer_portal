class Syndication < ActiveRecord::Base
  attr_accessible :title, :description, :url, :category_id, :protocol, :content_type

  filters_spam :message_field => :description,
               :author_field => :title

  has_and_belongs_to_many :categories, :class_name => 'SyndicationCategory'

  validates :title, :presence => true, 
                    :uniqueness => true,
                    :length => {:maximum => 255}

  validates :description, :length => {:maximum => 4096} # 4KB

  validates :url, :presence => true,
                  :uniqueness => true,
                  :length => {:maximum => 255}
  
  #TODO Validate url is reachable                  
  #TODO Validate existing category_id
  #TODO Validate existing protocol
  #TODO Validate existing content_type

  scope :unmoderated, :conditions => {:state => nil}
  scope :approved, :conditions => {:state => 'approved'}
  scope :rejected, :conditions => {:state => 'rejected'}

  # fitlers_spam adds
  # spam! / ham! to set spam true/false
  # spam? / ham? to find the value

  def approve!
    self.update_attributes :state, 'approved'
  end

  def reject!
    self.update_attributes :state, 'rejected'
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

  before_create do |feed|
    unless Syndication::Moderation.enabled?
      feed.state = feed.spam? ? 'rejected' : 'approved'
    end
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
