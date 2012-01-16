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
  before_save :maintain_ticket_state
  before_create :set_ticket_state
  after_create :project_viewers_watch_me
  
  def tag!(tags)
    tags = tags.split(" ").map do |tag|
      Tag.find_or_create_by_name(tag)
    end
    self.tags << tags
  end
  
  private
    def project_viewers_watch_me
      permissions = Permission.all.find_all {
        |item| item.thing_id == project.id && item.action == "view" && 
               item.thing_type == "Project" }
        users = permissions.map { |p| p.user_id }.compact
      self.watchers << User.find(users) unless users.empty?
    end
    
    def set_ticket_state
      self.state = State.find_by_default(true)
    end
    
    def maintain_ticket_state
      if self.state_id_was
        self.state = State.find(self.state_id_was) unless self.state
      end
    end
end
