class Notifier < ActionMailer::Base
  default from: "opsmailer@wizards.com"
  
  def comment_updated(comment, user)
    @comment = comment
    @user = user
    mail(:from => "WOTC OPSmailer <opsmailer@wizards.com>",
         :to => user.email,
         :subject => "[opsmailer+#{comment.project.id}+#{comment.ticket.id}@wizards.com] " +
         "#{comment.ticket.project.name} - #{comment.ticket.title}")
  end
end
