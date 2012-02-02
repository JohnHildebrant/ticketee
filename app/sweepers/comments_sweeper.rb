class CommentsSweeper < ActionController::Caching::Sweeper
  observe Comment
  def after_create(comment)
    expire_fragments_for_project(comment.ticket.project)
  end
  
  def expire_fragments_for_project(project)
    expire_fragment(/projects\/#{project.id}\/.*?/)
  end
end
