class Receiver < ActionMailer::Base
  require 'nokogiri'
  
  default from: "opsmailer@wizards.com"
  
  def self.parse(email)
    reply_separator = /(.*?)\s?== ADD YOUR REPLY ABOVE THIS LINE ==/m
    comment_text = reply_separator.match(email.body.decoded)
    if comment_text
      to, project_id, ticket_id = email.subject.split("@")[0].split("+")
      if project_id.to_i > 0 && ticket_id.to_i > 0
        project = Project.find(project_id)
        ticket = project.tickets.find(ticket_id)
        from_exp = /[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})/i
        from = from_exp.match(email.from[0])[0]
        from = from_exp.match(email.from[1])[0] unless from
        user = User.find_by_email(from)
        comment_text = Nokogiri::HTML(comment_text[1].strip).text
        comment_strip_exp = /^<!--.+-->(.+)$/
        comment_text = comment_strip_exp.match(comment_text) ? 
          comment_strip_exp.match(comment_text)[0] : comment_text
        ticket.comments.create(:text => comment_text, :user => user) if user
      end
    end
  end
end
