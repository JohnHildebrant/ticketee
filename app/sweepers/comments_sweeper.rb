class CommentsSweeper < ActionController::Caching::Sweeper
  observe Comment
  def after_create(comment)
    expire_fragments_for_ticket(comment.ticket)
  end
  
  private
    def expire_fragments_for_ticket(ticket)
      # clear ticket show
      expire_fragment(%r{projects/#{ticket.project.id}/tickets/#{ticket.id}})
      # clear project show pagination
      expire_fragment(%r{projects/#{ticket.project.id}/\d+})
    end
end
