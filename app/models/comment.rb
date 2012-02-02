class Comment < ActiveRecord::Base
  before_create :set_previous_state
  after_create :set_ticket_state
  after_create :creator_watches_ticket
  delegate :project, :to => :ticket
  
  belongs_to :ticket, :touch => true
  belongs_to :user
  belongs_to :state
  belongs_to :previous_state, :class_name => "State"
  validates :text, :presence => true
  
  private
    def set_ticket_state
      self.ticket.state = self.state
      self.ticket.save!
    end
    
    def set_previous_state
      self.previous_state = ticket.state
    end
    
    def creator_watches_ticket
      ticket.watchers << user unless ticket.watchers.include?(user)
    end
end
