class Ticket < ActiveRecord::Base
  searcher do
    label :tag, :from => :tags, :field => :name
    label :state, :from => :state, :field => :name
  end
  belongs_to :project
  belongs_to :state
  belongs_to :user
  validates :title, :presence => true
  validates :description, :presence => true, :length => { :minimum => 10 }
  has_many :assets
  accepts_nested_attributes_for :assets
  has_many :comments
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :watchers, :join_table => "ticket_watchers",
                                     :class_name => "User"
  before_create :set_ticket_state
  after_create :creator_watches_me
  
  def tag!(tags)
    tags = tags.split(" ").map do |tag|
      Tag.find_or_create_by_name(tag)
    end
    self.tags << tags
  end
  
  private
    def creator_watches_me
      self.watchers << user
    end
    
    def set_ticket_state
      self.state = State.all.find{|item| item.default}
    end
end
