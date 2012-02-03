class CommentNotifierJob < Struct.new(:comment_id)
  def perform    
    comment = Comment.find(comment_id)
    (comment.ticket.watchers - [comment.user]).each do |user|
      Notifier.comment_updated(comment, user).deliver
    ActionController::Base.new.
      expire_fragment(%r{projects/#{comment.ticket.project.id}/tickets/#{comment.ticket.id}})
    end
  end
end