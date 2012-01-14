class Receiver < ActionMailer::Base
  require 'rubygems'
  require 'nokogiri'
  
  default from: "opsmailer@wizards.com"
  
  def self.parse(email)
    reply_separator = /(.*?)\s?== ADD YOUR REPLY ABOVE THIS LINE ==/m
    full_text = Nokogiri::HTML(email.body.to_s).text
    comment_text = reply_separator.match(full_text)
    if comment_text
      to, project_id, ticket_id = email.subject.split("@")[0].split("+")
      if project_id.to_i > 0 && ticket_id.to_i > 0
        project = Project.find(project_id)
        ticket = project.tickets.find(ticket_id)
        user = User.find_by_email(email.from[0])
        ticket.comments.create(:text => comment_text[1].strip,
                               :user => user)
      end
    end
  end
end
