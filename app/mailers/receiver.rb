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
        user = User.find_by_email(email.from[0].downcase)
        comment_text = comment_text[1].strip
        comment_text = Nokogiri::HTML(comment_text).text
        comment_strip_exp = /^&lt;!--.+--&gt;(.+)$/m
        match_text = comment_strip_exp.match(comment_text)
        match_text[1].bomb
        ticket.comments.create(:text => comment_text, :user => user)
      end
    end
  end
end
