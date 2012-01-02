class Comment < ActiveRecord::Base
  after_create :set_ticket_state
  delegate :project, :to => :ticket
  
  belongs_to :ticket
  belongs_to :user
  belongs_to :state
  validates :text, :presence => true
  
  private
  
    def set_ticket_state
      self.ticket.state = self.state
      self.ticket.save!
    end
end
