class CommentNotifierJob < Struct.new(:comment_id)
  def perform    
    comment = Comment.find(comment_id)
    (comment.ticket.watchers - [comment.user]).each do |user|
      Notifier.comment_updated(comment, user).deliver
    ActionController::Base.new.
      expire_fragment(/projects\/#{comment.ticket.project.id}\/.*?/)
    end
  end
end