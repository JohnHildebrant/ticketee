class Admin::IncomingsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def create
    # Being invoked as a POST from the mail_poller
    mail = TMail::Mail.parse(params[:email])
  
    reply_separator = /(.*?)\s?== ADD YOUR REPLY ABOVE THIS LINE ==/m
    comment_text = reply_separator.match(mail.body)
    if comment_text
      to, project_id, ticket_id = mail.subject.split("@")[0].split("+")
      project = Project.find(project_id)
      ticket = project.tickets.find(ticket_id)
      user = User.find_by_email(mail.from[0])
      ticket.comments.create(:text => comment_text[1].strip,
                             :user => user)
    end
  end                
end