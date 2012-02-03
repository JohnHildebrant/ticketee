class TicketsSweeper < ActionController::Caching::Sweeper
  observe Ticket
  def after_create(ticket)
    expire_fragments_for_ticket(ticket)
  end
  
  def after_update(ticket)
    expire_fragments_for_ticket(ticket)
  end
  
  def after_destroy(ticket)
    expire_fragments_for_ticket(ticket)
  end
  
  private
    def expire_fragments_for_ticket(ticket)
      # clear ticket show
      expire_fragment(%r{projects/#{ticket.project.id}/tickets/#{ticket.id}})
      # clear project show pagination
      expire_fragment(%r{projects/#{ticket.project.id}/\d+})
    end
end
